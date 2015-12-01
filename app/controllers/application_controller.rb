class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def check_for_user!
    redirect_to root_path unless current_user
  end

  def current_user
    User.find_by( id: session[:user_id] )
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out(user=nil)
    session.delete(:user_id)
  end
end
