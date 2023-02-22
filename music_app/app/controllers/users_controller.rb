class UsersController < ApplicationController

  #sign up

  #step 0 : always make user_params first.

  #step 1 : create new  that renders sigh up form
  #step 2 : make sign up action by using create
  ###step2-A : make login function in Application_controller
  ###step2-B : goto Application_controller

  #step1

  def new
    @user = User.new
    render :new
  end

  def index
    render :index
  end

  #step 2
  def create
    @user = User.new(user_params)

    if @user.save
      login(@user)
      #redirect index || show for onw we can render :show
      redirect_to user_url(@user)
    else
      puts @user.errors.full_messages
      render :new
    end
  end

  #this is extra step but i mean after sign up they want to see their page right? its just simple common sesne buddy
  def show
    # user GET    /users/:id(.:format)   users#show
    @user = User.find(params[:id])
    render :show
  end

  #step 0
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
