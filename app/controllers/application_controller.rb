class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :signed_in?, :current_user

  private

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out!
    session[:user_id] = nil
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless signed_in?
      redirect_to root_path, alert: 'ログインしてください'
    end
  end
end
