class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate params[:session][:password]
      log_in @user
      check_remember
      flash[:success] = t "global.welcome", variable: @user.name
      redirect_to @user
    else
      flash.now[:danger] = t "global.error_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def check_remember
    params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
  end
end
