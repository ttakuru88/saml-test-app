class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:private]

  def index
  end

  def private
  end

  def sign_out
    sign_out!
    redirect_to root_path, notice: 'ログアウトしました'
  end
end
