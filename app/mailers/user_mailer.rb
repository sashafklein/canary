class UserMailer < ApplicationMailer

  def tweet_notification(user, tweet, term)
    @user, @tweet, @term = user, tweet, term

    mail(to: @user.email, subject: "@#{tweet[:user][:screen_name]} just sent out a tweet with the term: '#{term}'")
  end
end
