class ApplicationController < ActionController::Base
  before_action :set_locale

  include SessionsHelper

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "global.require_login"
    redirect_to login_url
  end

  def load_user
    @user = User.find_by id: params[:user_id]
    return if @user

    flash[:danger] = t "global.not_found"
    redirect_to root_url
  end
end
