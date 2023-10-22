class ConnectInvitesJob < ApplicationJob
  def perform(user_id)
    user = User.find(user_id)
    friendships = Friendship.without_invited.where("invited_email ilike :email", { email: "%#{user.email }%"} )
    friendships.update_all(invited_id: user.id)
  end
end
