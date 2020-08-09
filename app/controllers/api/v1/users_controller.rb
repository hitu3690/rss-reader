class Api::V1::UsersController < ApplicationController
  def me
    if current_user
      render json: current_user
    else
      render json: { error: 'ログインしてません' }, status: :not_found
    end
  end
  
  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: { error: 'エラーです' }, status: :bad_request
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
