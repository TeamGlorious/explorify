class UsersController < ApplicationController
  def index
    redirect_to root_path
  end

  def new
    @user = User.new
    @current_user = current_user
  end

  def create
    puts '*' * 50
    puts 'Creating new User!!!'
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    @user = User.create(user_params)
    redirect_to @user
  end

  def edit
  end

  def update
  end

  def show
    @user = User.find_by_id(params[:id])
    @current_user = current_user
  end

  def destroy
  end
end
