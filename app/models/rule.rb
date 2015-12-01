class Rule < ActiveRecord::Base

  PreexistingError = Class.new(StandardError)

  belongs_to :user
  validates_presence_of :twitter_user_id

  def self.create_from_twitter_user!(twitter_user:, term:)
    tu = twitter_user.symbolize_keys
    preexisting = self.where(twitter_user_id: tu[:twitter_user_id], term: term)

    raise PreexistingError.new("That rule already exists!") if preexisting.count > 0

    preexisting.create!( tu.slice(:twitter_user_name, :twitter_user_image).merge({ term: term }) )
  end

  def notify_if_found!(tweets, this_check_time, previous_check_time)
    matching = tweets.select do |tweet| 
      (previous_check_time..this_check_time).cover?( tweet[:created_at].to_datetime ) && 
        tweet[:text].include?( term )
    end

    matching.each do |tweet|
      user.notify_of_tweet!( tweet, term )
    end
  end
end
