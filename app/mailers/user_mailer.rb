class UserMailer < ActionMailer::Base
  default from: 'sample.app.4.0@gmail.com'

  def welcome_email(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(to: email_with_name, subject: "Welcome to my site")
  end

  def notify_new_follower(user, follower)
    @user = user
    @follower = follower
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(to: email_with_name, subject: "#{@user.name}, you have a new follower!")
  end

  def password_reset(user)
    @user = user
    mail(to: user.email, subject: "Reset your password")
  end

  def confirmation(user)
    @user = user
    mail(to: user.email, subject: "Confirmation of your signup.")
  end
end
