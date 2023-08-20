# == Schema Information
#
# Table name: lists
#
#  id         :bigint           not null, primary key
#  position   :integer          default(0), not null
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
  acts_as_list(top_of_list: 0, add_new_at: :top)

  after_create_commit :broadcast_creation
  after_update_commit :broadcast_update
  after_destroy_commit :broadcast_destroy

  belongs_to :user

  validates :user_id, presence: true
  validates :title, length: { in: 3..20 }, presence: true, uniqueness: { scope: :user_id}

  private

    def broadcast_creation
      broadcast_prepend_to "user_#{self.user_id}_lists", partial: "lists/list", locals: { list: self }, target: "user_#{self.user_id}_lists"
    end

    def broadcast_update
      broadcast_replace_to "user_#{self.user_id}_lists", partial: "lists/list", locals: { list: self }, target: self
    end

    def broadcast_destroy
      broadcast_remove_to "user_#{self.user_id}_lists", target: self
    end
end
