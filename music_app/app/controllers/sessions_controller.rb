class SessionsController < ApplicationController

  #Log in Page
  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:email], params[:user][:password])
    # debugger
    if @user
      login(@user)
      redirect_to user_url(@user) #back to our welcom page
    else
      render :new
    end
  end
end
