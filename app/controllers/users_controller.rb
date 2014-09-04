class UsersController < ApplicationController
  def index
    redirect_to root_path
  end

  def new
    @user = User.new
    @current_user = current_user
  end

  def create
    user_params = params.require(:user).permit(:name, :email, :email_confirmation, :password, :password_confirmation)
    # @user = User.new(user_params)
    @user = User.create(user_params)
    invalid = "Invalid entry: "
    # if @user.save
    # else
    #   binding.pry
    #   flash.now[:notice] = "Activerecord error!"
    # end
    
    if @user.errors.count > 0
      @user.errors.each do |key, value|
        flash.now[:notice] = "#{invalid} #{key} #{value}"
      end
    end
    if user_params[:email] != user_params[:email_confirmation]
      flash.now[:notice] = "Your emails dont match."
      @user = User.new(user_params)
      render :new
    end
    if user_params[:password] != user_params[:password_confirmation]
      flash.now[:notice] = "Your passwords dont match"
      @user = User.new(user_params)
      render :new
    end
    if flash.count > 0
      @user.destroy
      @user = User.new(user_params)
      render :new
    else
      binding.pry
      puts '*' * 50
      puts 'Creating new User!!!'
      @user = User.authenticate(@user.email, user_params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "Account Created"
      flash[:notice] = "You've logged in!"
      redirect_to @user  
    end
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
