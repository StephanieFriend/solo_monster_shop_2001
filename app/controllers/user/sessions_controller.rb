class User::SessionsController < ApplicationController

  def create
    user = User.find_by(email_address: params[:email_address])
    if !user.nil? && user.authenticate(params[:password]) && user.active?
      session[:user_id] = user.id
      flash[:success] = "Welcome #{user.name}! You are now logged in!"
      redirect_based_on_role(user.role)
    elsif !user.nil? && !user.active? && user.authenticate(params[:password])
      flash[:error] = "Your account has been disabled"
      redirect_to '/'
    else
      flash[:error] = "Your email or password is incorrect"
      redirect_to '/login'
    end
  end
end
