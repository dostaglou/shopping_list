# == Schema Information
#
# Table name: friendships
#
#  id            :bigint           not null, primary key
#  invited_email :string           not null
#  status        :integer          default("pending"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  invited_id    :bigint
#  inviter_id    :bigint           not null
#
# Indexes
#
#  index_friendships_on_invited_id  (invited_id)
#  index_friendships_on_inviter_id  (inviter_id)
#
# Foreign Keys
#
#  fk_rails_...  (invited_id => users.id)
#  fk_rails_...  (inviter_id => users.id)
#
class Friendship < ApplicationRecord
  attr_accessor :name

  after_create_commit :set_invited_and_invite
  belongs_to :inviter, class_name: :User, foreign_key: :inviter_id
  belongs_to :invited, class_name: :User, foreign_key: :invited_id, optional: true
  validates :invited_email, presence: true
  has_many :shared_lists, dependent: :destroy
  accepts_nested_attributes_for :shared_lists

  scope :friendships_for, -> (user_id) { where(inviter_id: user_id).or(where(invited_id: user_id)) }

  validates :invited_email, uniqueness: { scope: :inviter_id, case_sensitive: false }
  validates :invited_id, uniqueness: { scope: :inviter_id }, allow_blank: true

  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }

  private

    def set_invited_and_invite
      user = User.where("email ilike ?", self.invited_email).first
      if user.nil?
        UserMailer.new_user_invitation(name, self.id).deliver_later
      else
        self.update(invited_id: user.id)
        UserMailer.invitation(self.id)
      end
    end
end
