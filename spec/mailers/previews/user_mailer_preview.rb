# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def tweet_notification
    UserMailer.tweet_notification(User.first, { user: { screen_name: 'Fake' }, text: 'Here is some Lorem Ipsum for you!', id: 667754734544031744}, 'Lorem')
  end
end

