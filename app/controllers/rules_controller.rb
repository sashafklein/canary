class RulesController < ApplicationController

  before_action :authenticate_user!
  before_action :load_user

  def index

  end

  private

  def load_user
    @user = User.find( params[:id] )
  end
end