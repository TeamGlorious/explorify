class SessionsController < ApplicationController

  def new
    # Login Form
  end

  def create
    @user = User.authenticate(params[:user][:email], params[:user][:password])

    if @user
      session[:user_id] = @user.id
      redirect_to @user, :notice => "You've logged in!"
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session["access_token"] = nil
    redirect_to root_path
  end
end
