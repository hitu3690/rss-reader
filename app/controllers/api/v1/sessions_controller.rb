class Api::V1::SessionsController < ApplicationController
  def create
    # if request.env["omniauth.auth"].present?
    #   user = User.from_omniauth(request.env["omniauth.auth"])
    #   if user.save
    #     session[:user_id] = user.id
    #     render json: user
    #   else
    #     render json: { error: 'エラーです' }, status: :bad_request
    #   end
    # else
      user = User.find_by(email: session_params[:email])
      if user&.authenticate(session_params[:password])
        session[:user_id] = user.id
        render json: user
      else
        render json: { error: 'エラーだよ' }, status: :bad_request
      end
    # end
  end

  def destroy
    reset_session
    head :ok
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end
end
