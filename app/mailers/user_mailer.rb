class UserMailer < ApplicationMailer
  before_action :set_header

  def invitation(friendship_id)
    friendship = Friendship.find friendship_id
    @email = friendship.invited.email
    @inviter = friendship.inviter
    @invited = frienship.invited

    mail(to: @email, subject: "You have an invitation")
  end

  def new_user_invitation(name, friendship_id)
    @name = name
    friendship = Friendship.find friendship_id
    @email = friendship.invited_email
    @inviter = friendship.inviter

    mail(to: @email, subject: "You have an invitation")
  end

  private

    def set_header
      headers "X-SMTPAPI" => { category: ["User"] }.to_json
    end

    def bob
    end
end
