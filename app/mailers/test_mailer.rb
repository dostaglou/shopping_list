class TestMailer < ApplicationMailer
  def testing
    @user = User.first
    mail(to: @user.email, subject: "Testing")
  end
end
