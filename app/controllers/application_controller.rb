class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def require_login
    puts "checking login"
    puts session[:user_jwt]
    unless session[:user_jwt]
      redirect_to login_url # halts request cycle
    end
  end
end
