class OmniauthsController < ApplicationController

  def back
    user = User.from_auth_data( auth )
    
    sign_in_and_redirect(user)
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def sign_in_and_redirect(user)
    sign_in user

    if user.email
      redirect_to user_rules_path(user)
    else
      flash[:error] = "Please input an email to continue"
      redirect_to edit_user_path(user)
    end
  end

  def consumer
    auth.extra.access_token.consumer
  end

  def info
    auth.extra.access_token.params
  end

  def info

  end

  def auth
    @auth ||= request.env["omniauth.auth"]
  end
end