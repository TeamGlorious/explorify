class SessionsController < ApplicationController

  def create
    @user = User.authenticate(params[:user][:email], params[:user][:password])

    if @user
      session[:user_id] = @user.id
    else
      render text: "Invalid login!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect to root_path
  end
end
