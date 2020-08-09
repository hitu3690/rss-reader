class ApplicationController < ActionController::API

  private
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  # helper_method :current_user
  #
  # def current_user
  #   if session[:user_id]
  #     @current_user ||= User.find_by(id: session[:user_id])
  #   end
  # end
  #
  # def logged_in_user
  #   if current_user.nil?
  #     redirect_to login_url
  #   end
  # end
end
