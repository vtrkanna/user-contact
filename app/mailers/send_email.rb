class SendEmail < ApplicationMailer
  def welcome_email(user, sub)
        @user = User.find user.id
         mail(to: user.email, subject: sub)
  end
  def sign_up_email(email, sub, user)
    @email = email
    @user = user
    mail(to: email, subject: sub)
  end
end
