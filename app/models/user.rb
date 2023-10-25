# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  after_create_commit :link_friendships
  before_save -> { self.email = self.email.strip }, if: -> { will_save_change_to_email? }
  before_save -> { self.username = self.username.strip }, if: -> { will_save_change_to_username? }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create_commit :connect_invites

  has_many :lists, dependent: :destroy
  has_many :invites, dependent: :destroy, class_name: :Friendship, foreign_key: :inviter_id
  has_many :inviteds, dependent: :destroy, class_name: :Friendship, foreign_key: :invited_id
  validates :username, presence: true, length: { in: 4..40 }

  private

    def link_friendships
      friendships = Friendship.pending.where(invited_id: nil).where(invited_email: self.email)
      friendships.update_all(updated_at: Time.now, invited_id: self.id)
    end

    def connect_invites
      ConnectInvitesJob.perform_now(self.id)
    end
end
