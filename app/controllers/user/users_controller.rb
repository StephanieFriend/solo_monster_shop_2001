class User::UsersController < User::BaseController

  def profile
    @user = User.find(session[:user_id])
  end

  def orders
    @user = User.find(session[:user_id])
    @orders = @user.orders
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    if @user.save
      flash[:message] = "Your information is updated"
      if current_admin?
        redirect_to "/admin/users/#{@user.id}"
      else
        redirect_to :user_profile
      end
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to :user_profile_edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :street_address, :city, :state, :zip_code, :email_address)
  end
end
