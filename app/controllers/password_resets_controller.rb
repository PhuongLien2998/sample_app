class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email]
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "global.sent_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t "global.sent_mail_faild"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t("global.error_pass")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "global.reset_pass_done"
      redirect_to @user
    else
      flash.now[:danger] = t "global.reset_pass_faild"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    return if @user = User.find_by(email: params[:email])

    flash[:danger] = t "global.not_found"
    redirect_to root_url
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    flash[:danger] = t "global.invalid_user"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "global.link_reset_expired"
    redirect_to new_password_reset_url
  end
end
