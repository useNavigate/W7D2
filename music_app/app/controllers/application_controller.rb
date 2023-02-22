class ApplicationController < ActionController::Base
  # skip_before_action :verify_authenticity_token

  #step2-1 : make login function in Application_controller
  #step 3 def current user
  #step 4 logged_in?
  ### we needed step 3 for this to check if current user is logged in
  #step 5 use helper method to render in view

  #step 5
  helper_method :current_user, :logged_in?
  #we pass down :logged_in? to implement the logic since it gives us boolean return

  #step2-1
  def login(user)
    session[:session_token] = user.reset_session_token!
  end

  #step3
  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  #step 4
  def logged_in?
    !!current_user
  end
end
