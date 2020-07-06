class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      render file: "public/tables.html"
    else
      redirect_to root_url
    end
  end

  def show
    @user = User.find(params[:id])
    if @user.id == session[:user_id]
      render file: "public/tables.html"
    else
      redirect_to root_url
    end
  end

  def destroy
  end

  private
    def user_params
      params.require(:user).permit(:name, :email)
    end
end
