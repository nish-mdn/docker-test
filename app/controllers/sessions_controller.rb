class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :new_signup, :signup]

  def new
  end

  def create
    result = AuthServiceClient.sign_in(params[:email], params[:password])

    if result[:success]
      session[:auth_token] = result[:body]["token"]
      session[:user_email] = result[:body].dig("user", "email")
      redirect_to session.delete(:return_to) || root_path, notice: "Signed in successfully."
    else
      flash.now[:alert] = result[:body]["message"] || "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error("Auth service error: #{e.message}")
    flash.now[:alert] = "Authentication service is unavailable. Please try again later."
    render :new, status: :service_unavailable
  end

  def new_signup
  end

  def signup
    result = AuthServiceClient.sign_up(params[:email], params[:password], params[:password_confirmation])

    if result[:success]
      session[:auth_token] = result[:body]["token"]
      session[:user_email] = result[:body].dig("user", "email")
      redirect_to root_path, notice: "Account created successfully."
    else
      errors = result[:body]["errors"]
      flash.now[:alert] = errors.is_a?(Array) ? errors.join(", ") : (result[:body]["message"] || "Signup failed.")
      render :new_signup, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error("Auth service error: #{e.message}")
    flash.now[:alert] = "Authentication service is unavailable. Please try again later."
    render :new_signup, status: :service_unavailable
  end

  def destroy
    token = session[:auth_token]
    AuthServiceClient.sign_out(token) if token
    reset_session
    redirect_to login_path, notice: "Signed out successfully."
  rescue StandardError => e
    Rails.logger.error("Logout error: #{e.message}")
    reset_session
    redirect_to login_path, notice: "Signed out successfully."
  end
end
