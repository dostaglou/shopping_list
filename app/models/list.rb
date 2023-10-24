# == Schema Information
#
# Table name: lists
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_lists_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class List < ApplicationRecord
  after_create_commit :broadcast_creation
  after_update_commit :broadcast_update
  after_destroy_commit :broadcast_destroy

  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :shared_lists, dependent: :destroy
  has_many :friendships, through: :shared_lists, source: :friendship

  validates :user_id, presence: true
  validates :title, length: { in: 3..20 }, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }

  private

    def broadcast_creation
      broadcast_prepend_to "user_#{self.user_id}_list_#{self.id}", partial: "lists/list", locals: { list: self, items: [] }, target: "user_#{self.user_id}_lists"
    end

    def broadcast_update
      broadcast_replace_to "user_#{self.user_id}_lists", partial: "lists/list", locals: { list: self, items: self.items.by_status }, target: self
    end

    def broadcast_destroy
      broadcast_remove_to "user_#{self.user_id}_lists", target: self
    end
end
