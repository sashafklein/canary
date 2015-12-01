task check_tweets: :environment do 
  User.where( id: Rule.pluck(:user_id).uniq ).find_each do |user|
    TweetCheck.new(user: user).run!
  end
end