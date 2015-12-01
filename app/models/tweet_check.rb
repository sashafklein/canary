class TweetCheck < ActiveRecord::Base
  belongs_to :user
  
  attr_accessor :now, :tweets, :twitter_client
  after_initialize do
    self.now = Time.now
    self.tweets = {}
    self.twitter_client = user.twitter_client
  end

  scope :after, lambda { |time| where('tweet_checks.created_at > ?', time) }

  PreexistingError = Class.new(StandardError)
  
  def run!
    if most_recent.nil?
      save! # Don't ever search before the date the rule was made
    elsif most_recent.created_at > now - 5.minutes
      # Rollbar
      raise PreexistingError.new("A TweetCheck was performed in the last 5 minutes for user #{user.username}!")
    else
      perform_tweet_check!
    end
  end

  private

  def perform_tweet_check!
    ActiveRecord::Base.transaction do
      user.rules.each do |rule|
        ts = tweets[ rule.twitter_user_name ] ||= tweet_timeline(rule)
        rule.notify_if_found!( ts, now, most_recent.created_at )
      end

      update_attributes!( created_at: now, updated_at: now )
    end
  rescue Twitter::Error::NotFound => e
    # Rollbar
  end

  def most_recent
    @most_recent ||= TweetCheck.where(user_id: user.id).order(created_at: :desc).first
  end

  def following
    @following ||= user.following_on_twitter_complete
  end

  def tweet_timeline(rule)
    twitter_client.user_timeline( rule.twitter_user_id.to_i ).map(&:to_hash)
  rescue 
    []
  end
end