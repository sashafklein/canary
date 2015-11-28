class LandingsController < ApplicationController

  layout 'layouts/landing'

  def show
    return redirect_to user_rules_path(current_user) if current_user
  end
  
end