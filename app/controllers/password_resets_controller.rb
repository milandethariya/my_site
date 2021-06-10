class PasswordResetsController < ApplicationController
	before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  def new
  end

  def edit

  end

  def create
  	@user = User.find_by(email: params[:reset_password][:email])
  	if @user
  		@user.create_reset_digest
  		render 'static_pages/reset'
		else
			flash.now[:danger] = "email is not found!"
			render 'new'
		end
	end

	def update
		if params[:user][:password].empty?
	    @user.errors.add(:password, "can't be empty")
	    render 'edit'
	  elsif @user.update_attributes(user_params)
	    log_in @user
	    flash[:success] = "Password has been reset."
	    redirect_to @user
	  else
	    render 'edit'
	  end
	end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Confirms a valid user.
  def valid_user
    unless (@user && @user.activated? &&
            @user.authenticated_reset?(params[:id]))
      redirect_to root_url
    end
  end


end
