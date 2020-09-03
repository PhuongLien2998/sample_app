class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate params[:session][:password]
      log_in @user
      flash[:success] = t("global.welcome", variable: @user.name)
      redirect_to @user
    else
      flash.now[:danger] = t "global.error_login"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
