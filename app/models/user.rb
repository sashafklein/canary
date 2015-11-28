class User < ActiveRecord::Base

  def self.from_auth_data( auth )
    token = auth[:extra][:access_token]

    where( twitter_id: token.params[:user_id] )
      .first_or_create(
        twitter_key: token.token,
        twitter_secret: token.secret,
        username: token.params[:screen_name],
        email: token.params[:email],
        image: auth[:info][:image]
      )
  end

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_KEY"]
      config.consumer_secret = ENV["TWITTER_SECRET"]
      config.access_token = twitter_key
      config.access_token_secret = twitter_secret
    end
  end
  
end
