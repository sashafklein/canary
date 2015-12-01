class User < ActiveRecord::Base

  has_many :rules

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

  def following_on_twitter
    @following_on_twitter ||= twitter_client.following.attrs[:users].map{ |u| twitter_user_attrs(u) }
  rescue
    []
  end

  private

  def twitter_user_attrs(u)
    { twitter_user_name: u[:name], twitter_user_id: u[:id], twitter_user_image: u[:profile_image_url_https] }
  end
  
end
