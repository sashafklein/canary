require 'rails_helper'

describe OmniauthsController do
  
  describe "back" do
    context "no existing user" do
      context "with complete information" do
        it "calls 'User.from_auth_data', signs them in, and sends them onto the rules path" do
          expect( session[:user_id] ).to be_nil
          expect(User).to receive('from_auth_data').and_return( user = User.create(email: 'email@fake.com', twitter_id: '12345') )

          get :back

          expect( session[:user_id] ).to eq user.id
          expect( response ).to redirect_to user_rules_path(user)
        end
      end

      context "without email" do
        it "calls 'User.from_auth_data', signs them in, and sends them to add an email" do
          expect( session[:user_id] ).to be_nil
          expect(User).to receive('from_auth_data').and_return( user = User.create(twitter_id: '12345') )

          get :back

          expect( session[:user_id] ).to eq user.id
          expect( response ).to redirect_to edit_user_path(user)
        end
      end
    end
  end

  describe "destroy" do
    it "signs the user out" do
      session[:user_id] = (user = User.create).id
      expect( session[:user_id] ).to eq user.id
      post :destroy
      expect( response ).to redirect_to root_path
      expect( session[:user_id] ).to be_nil
    end
  end
end

def user_rules_path(user)
  "/users/#{ user.id }/rules"
end