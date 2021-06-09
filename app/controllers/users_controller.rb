class UsersController < ApplicationController
  def index 
    @users = User.all
  end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in(@user)
      flash[:sucess] = "Welcome to the Sample App!" 
  		redirect_to user_path(@user[:id])
		else
			render 'users/new'
		end
	end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to user_path(@user[:id])
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
