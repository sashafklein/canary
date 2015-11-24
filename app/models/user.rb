class User < ActiveRecord::Base

  def self.from_auth_data( auth )
    info = auth.info
    consumer = auth.extra.access_token.consumer
    params = auth.extra.access_token.params

    where( twitter_id: params[:user_id] )
      .first_or_create(
        twitter_key: consumer.key,
        twitter_secret: consumer.secret,
        username: params[:screen_name],
        email: params[:email],
        image: info.image
      )
  end
end
