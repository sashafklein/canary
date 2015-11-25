require 'rails_helper'
require 'ostruct'

describe User do 

  before { User.destroy_all }

  describe '.from_auth_data' do
    context "without preexisting user" do
      it "creates a user from the data" do
        expect{ @user = User.from_auth_data( auth_data ) }.to change { User.count }.from(0).to(1)
        expect( @user.attributes.symbolize_keys.except(:id, :updated_at, :created_at) ).to eq(auth_data_hash)
      end
    end

    context "with preexisting user" do

      before { User.create(auth_data_hash) }

      it "finds the user and returns it" do
        expect( User.count ).to eq 1
        expect{ @user = User.from_auth_data( auth_data ) }.not_to change { User.count }
        expect( @user.attributes.symbolize_keys.except(:id, :updated_at, :created_at) ).to eq(auth_data_hash)
      end
    end
  end
end

def auth_data
  @auth_data ||= {
    info: {
      image: auth_data_hash[:image]
    },
    extra: {
      access_token: OpenStruct.new({
        params: {
          user_id: auth_data_hash[:twitter_id],
          screen_name: auth_data_hash[:username],
          email: auth_data_hash[:email]
        },
        consumer: OpenStruct.new({
          key: auth_data_hash[:twitter_key],
          secret: auth_data_hash[:twitter_secret]
        })
      })
    }
  }
end

def auth_data_hash
  {
    username: 'username',
    image: 'image.jpg',
    email: 'email@fake.com',
    twitter_id: '12345',
    twitter_key: 'ck1234',
    twitter_secret: 'cs1234'
  }
end