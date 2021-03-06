class TweetCheck < ActiveRecord::Base
  belongs_to :user
  
  after_save { puts "TweetCheck performed for #{user.email}: #{self.created_at}" }
  
  attr_accessor :now, :tweets, :twitter_client
  after_initialize do
    self.now = Time.now
    self.tweets = {}
    self.twitter_client = user.twitter_client
  end

  scope :after, lambda { |time| where('tweet_checks.created_at > ?', time) }
  
  def run!
    if most_recent.nil?
      save! # Don't ever search before the date the rule was made
    elsif most_recent.created_at > now - 5.minutes
      Rollbar.error("A TweetCheck was performed in the last 5 minutes for user #{user.username}!")
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
    Rollbar.error("Twitter::Error::NotFound for user #{user.username}: #{e.message}")
  rescue => e
    Rollbar.error("Unexpected error: #{e.message}")
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