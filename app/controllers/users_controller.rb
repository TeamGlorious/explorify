class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def create
    puts '*'*50
    puts 'Creating new User!!!'
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    user = User.create(user_params)
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
  end
end
