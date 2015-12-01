require 'rails_helper'

describe Rule do
  describe '.create_from_twitter_user!' do

    let(:user) { nu = new_user; nu.save; nu }

    before{ User.destroy_all; Rule.destroy_all }

    it "creates a rule from a twitter_user hash and term" do
      expect{ 
        create_rule!(user)
      }.to change{ user.rules.where( twitter_user_name: 'User Name' ).count }.to 1
    end

    it "throws an error without an id in the hash" do
      expect{
        create_rule!(user, nil)
      }.to raise_error ActiveRecord::RecordInvalid
      expect( user.rules.count ).to eq 0
    end

    it "raises an error if the rule already exists" do
      create_rule!(user)
      expect{ create_rule!(user) }.to raise_error Rule::PreexistingError
    end

    it "doesn't raise an error if another user has that rule" do
      create_rule!(user)
      nu = new_user(2); nu.save
      expect{ create_rule!(nu) }.not_to raise_error
    end
  end
end

def twitter_user_hash(id)
  { twitter_user_id: id, twitter_user_image: 'abc.jpg', twitter_user_name: 'User Name' }
end

def create_rule!(u, id=1)
  u.rules.create_from_twitter_user!( twitter_user: twitter_user_hash(id), term: 'whatwhat' )
end
