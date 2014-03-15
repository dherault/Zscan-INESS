#encoding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :error, :success
  
  before_action :check_session, :check_su

  def check_session
  	unless session[:shop_id]
  		session[:return_to] = request.url
  		redirect_to before_login_path, error: "Vous devez vous connecter"
  	end
  end

  def check_su
    unless session[:shop_level] == 10
      redirect_to root_path, error: "Vous ne disposez pas des droits suffisants"
    end
  end

end
