class SessionsController < ApplicationController
  protect_from_forgery :except => [:create, :destroy]
  include SessionsHelper

  def new
  end

  def create
    if request.env["omniauth.auth"].present?
      # Google認証
      @user = User.from_omniauth(request.env["omniauth.auth"])
      if @user.save
        session[:user_id] = @user.id
        redirect_to "/table.html"
      else
        redirect_to "/home.html"
      end
    else
      # 通常ログイン
      @user = User.find_by(email: params[:session][:email])
      if @user && @user.authenticate(params[:session][:password])
        session[:user_id] = @user.id
        redirect_to "/table.html"
      else
        redirect_to "/home.html"
      end
    end
  end

  def destroy
    session[:user_id] = nil
    @current_user = nil
    redirect_to root_url
  end
end
