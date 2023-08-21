class Item < ApplicationRecord
  belongs_to :list

  after_create_commit :broadcast_creation
  after_update_commit :broadcast_update
  after_destroy_commit :broadcast_destroy

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

  private

    def broadcast_creation
      top_item = "#{self.list_id}_top_item"
      broadcast_after_to "user_#{self.list.user_id}_lists", partial: "items/item", locals: { item: self }, target: top_item
    end

    def broadcast_update
      broadcast_replace_to "user_#{self.list.user_id}_lists", partial: "items/item", locals: { item: self }, target: "item_#{self.id}"
    end

    def broadcast_destroy
      broadcast_remove_to "user_#{self.list.user_id}_lists", target: "item_#{self.id}"
    end
end
