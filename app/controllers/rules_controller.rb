class RulesController < ApplicationController

  before_action :check_for_user!
  before_action :load_user
  before_action :authenticate_user!

  def index
  end

  def create
    unless (twitter_user = eval(params[:twitter_user])) && params[:term]
      return throw_error 
    end

    if @user.rules.create_from_twitter_user!( twitter_user: twitter_user, term: params[:term] )
      flash[:success] = "New rule saved successfully!"
      redirect_to user_rules_path(@user)
    else
      flash[:error] = "Something went wrong."
      throw_error
    end
  end

  def new
    @rule = @user.rules.new
  end

  private

  def load_user
    @user = User.find( params[:user_id] )
  end

  def authenticate_user!
    redirect_to root_path unless current_user == @user
  end

  def throw_error
    flash[:error] = "Something went wrong."
    redirect_to @user ? user_rules_path(@user) : root_path
  end
end