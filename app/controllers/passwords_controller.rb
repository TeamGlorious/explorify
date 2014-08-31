class PasswordsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user
      user.set_password_reset

      UserMailer.password_reset(user).deliver
    end
    redirect_to login_path, notice: "Email was sent with instructions"
  end

  def edit
    @code = params[:id]
  end

  def update
    user = User.find_by_code(params[:id])
    user.update_attributes(password: params[:password][0], password_confirmation: params[:password_confirmation][0])
    redirect_to login_path notice: "Password has changed, please login"
  end
end
