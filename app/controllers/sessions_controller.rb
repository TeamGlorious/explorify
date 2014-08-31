class SessionsController < ApplicationController

  def create
    @user = User.authenticate(params[:user][:email], params[:user][:password])

    if @user
      session[:user_id] = @user.id
    else
      render text: "Invalid login!"
    end
    redirect_to @user
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
