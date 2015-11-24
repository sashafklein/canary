class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out(user=nil)
    session.delete(:user_id)
  end

  def user_rules_path(user)
    root_path
  end
end
