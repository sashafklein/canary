task check_tweets: :environment do 
  User.all.find_each do |user|
    TweetCheck.new(user: user).run!
  end
end