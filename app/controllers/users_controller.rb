class UsersController < ApplicationController
  protect_from_forgery :except => [:create, :show]

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
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
