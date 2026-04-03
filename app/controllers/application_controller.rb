class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  helper_method :current_user_email, :logged_in?

  private

  def authenticate_user!
    return if logged_in?

    session[:return_to] = request.original_url
    redirect_to login_path, alert: "You must sign in to access this page."
  end

  def logged_in?
    return false unless session[:auth_token]

    payload = AuthServiceClient.verify_token(session[:auth_token])
    if payload
      true
    else
      reset_session
      false
    end
  end

  def current_user_email
    session[:user_email]
  end
end
