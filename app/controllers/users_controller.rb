class UsersController < ApplicationController
  protect_from_forgery :except => [:create, :show]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to "/table.html"
    else
      render "/"
    end
  end

  def show
    @user = User.find(params[:id])
    if @user.id == session[:user_id]
      redirect_to "/table.html"
    else
      render "/"
    end
  end

  def destroy
    User.find(params[:id]).destroy
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
