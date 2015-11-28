class UsersController < ApplicationController
  before_action :load_user

  def edit
  end

  def update
    if validish_email? && @user.update_attributes!(user_params)
      redirect_to user_rules_path(@user)
    else
      flash[:error] = "Please enter a valid email address."
      render :edit
    end
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end

  def validish_email?
    user_params[:email].present? && user_params[:email].include?('.') && user_params[:email].include?('@')
  end
end