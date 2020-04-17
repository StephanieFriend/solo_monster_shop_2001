class PasswordsController <ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    if @user.save
      flash[:message] = "Your password is updated"
      redirect_to :user_profile
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to :edit_password
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
