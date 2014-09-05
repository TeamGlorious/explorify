class SessionsController < ApplicationController

  def new
    # Login Form
    @user = User.new
  end

  def create
    @user = User.authenticate(params[:user][:email], params[:user][:password])

    if @user
      session[:user_id] = @user.id
      redirect_to @user, :notice => "You've logged in!"
    else
      flash.now[:notice] = "Invalid email or password"
      @user = User.new(email: params[:user][:email])
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session["access_token"] = nil
    redirect_to root_path
  end
end
