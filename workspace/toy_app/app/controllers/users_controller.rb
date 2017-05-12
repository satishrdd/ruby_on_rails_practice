class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :show,:destroy]
  before_action :correct_user , only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  def show 
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in @user
  		 flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end
  def new
    @user = User.new
  end
  def edit
    @user = User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
    
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in to access"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      if @user!=current_user
        flash[:danger] = "Authorization required to access this page"
        redirect_to(root_url) 
      end
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
