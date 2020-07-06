class SessionsController < ApplicationController
  protect_from_forgery :except => [:create, :destroy]
  include SessionsHelper

  def new
    render file: "public/login.html"
  end

  def create
    @user = User.find_by(mail: params[:session][:email])
    session[:user_id] = @user.id
    render file: "public/tables.html"
  end

  def google_create
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.save
      session[:user_id] = @user.id
      render file: "public/tables.html"
    else
      redirect_to root_url
    end
  end

  def destroy
    session[:user_id] = nil
    @current_user = nil
    redirect_to root_url
  end
end
