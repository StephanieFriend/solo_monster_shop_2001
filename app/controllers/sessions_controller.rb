class SessionsController < ApplicationController

  def new
    if !current_user.nil?
      flash[:message] = "#{current_user.name}! You are already logged in!"
      redirect_based_on_role(current_user.role)
    end
  end


end
