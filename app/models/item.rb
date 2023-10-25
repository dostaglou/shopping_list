# == Schema Information
#
# Table name: items
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  note       :string
#  quantity   :integer          default(0), not null
#  status     :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  list_id    :bigint           not null
#
# Indexes
#
#  index_items_on_list_id  (list_id)
#
class Item < ApplicationRecord
  belongs_to :list

  after_create_commit :broadcast_creation
  after_update_commit :broadcast_update

  validates :status, presence: true
  validates :name, presence: true, length: { in: 3..20 }
  validates :note, length: { in: 3..80, allow_blank: true }
  validates :quantity, numericality: { only_integer: true, in: 1..100 }

  enum status: {
    pending: 0,
    retrieved: 1
  }

  scope :by_status, ->(direction = :asc) { order(status: direction, name: :asc) }
  scope :order_by, ->(order_hash = {}) { order(order_hash.merge(status: :asc)) }

  validates :name, length: { in: 3..20 }, presence: true, uniqueness: { scope: :list_id, case_sensitive: false }

  def shared_users
    User.where(id: self.list.friendships.pluck(:invited_id, :inviter_id).flatten).excluding(self.list.user)
  end

  private

    def broadcast_creation
      top_item = "#{self.list_id}_top_item"
      self.shared_users.each do |target_user|
        broadcast_after_to "user_#{target_user.id}_lists", partial: "items/item", locals: { item: self }, target: top_item
      end

      broadcast_after_to "user_#{self.list.user_id}_lists", partial: "items/item", locals: { item: self }, target: top_item
    end

    def broadcast_update
      self.shared_users.each do |target_user|
        broadcast_replace_to "user_#{target_user.id}_lists", partial: "items/item", locals: { item: self }, target: "item_#{self.id}"
      end

      broadcast_replace_to "user_#{self.list.user_id}_lists", partial: "items/item", locals: { item: self }, target: "item_#{self.id}"
    end
end
