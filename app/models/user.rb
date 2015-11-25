class User < ActiveRecord::Base

  def self.from_auth_data( auth )
    info = auth[:info]
    consumer = auth[:extra][:access_token].consumer
    params = auth[:extra][:access_token].params

    where( twitter_id: params[:user_id] )
      .first_or_create(
        twitter_key: consumer.key,
        twitter_secret: consumer.secret,
        username: params[:screen_name],
        email: params[:email],
        image: info[:image]
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
