require 'rails_helper'

describe TweetCheck do
  before do 
    User.destroy_all; TweetCheck.destroy_all; Rule.destroy_all
    @user = (nu = new_user; nu.save; nu)
    @term = 'findme'
    @rule = @user.rules.create!( twitter_user_hash(1).merge({term: @term}) )
  end

  describe 'run!' do

    it "saves a TweetCheck but does nothing else the first time" do
      tweet_hash = { text: 'Here is some findme text', created_at: 5.days.ago.to_s }
      expect( @user ).not_to receive(:notify_of_tweet!)
      expect_any_instance_of(TweetCheck).not_to receive(:perform_tweet_check!)

      expect{
        TweetCheck.new(user: @user).run!
      }.to change{ TweetCheck.where(user: @user).count }.by 1
    end

    it "saves a TweetCheck and notifies user if a matching tweet has been released since previous" do
      TweetCheck.new(user: @user, created_at: 15.minutes.ago).save!
      tweet_hash = { text: 'Here is some findme text', created_at: 10.minutes.ago.to_s }
      allow_any_instance_of(TweetCheck).to receive(:tweet_timeline).and_return([tweet_hash])
      
      expect( @user ).to receive(:notify_of_tweet!).with(tweet_hash, @term)
      
      expect{
        TweetCheck.new(user: @user).run!
      }.to change{ TweetCheck.where(user: @user).count }.by 1
    end

    it "throws an error if a check has been recently performed" do
      TweetCheck.new(user: @user, created_at: 3.minutes.ago).save!
      tweet_hash = { text: 'Here is some findme text', created_at: 2.minutes.ago.to_s }
      expect( @user ).not_to receive(:notify_of_tweet!).with(tweet_hash, @term)
      expect( Rollbar ).to receive(:error).with("A TweetCheck was performed in the last 5 minutes for user #{@user.username}!")
      
      TweetCheck.new(user: @user).run!
    end

    it "ignores older tweets (doesn't notify, but creates a TweetCheck)" do
      TweetCheck.new(user: @user, created_at: 30.minutes.ago).save!
      tweet_hash = { text: 'Here is some findme text', created_at: 45.minutes.ago.to_s }
      allow_any_instance_of(TweetCheck).to receive(:tweet_timeline).and_return([tweet_hash])
      
      expect( @user ).not_to receive(:notify_of_tweet!)
      
      expect{
        TweetCheck.new(user: @user).run!
      }.to change{ TweetCheck.where(user: @user).count }.by 1
    end
  end
end

def twitter_user_hash(id)
  { twitter_user_id: id, twitter_user_image: 'abc.jpg', twitter_user_name: 'User Name' }
end