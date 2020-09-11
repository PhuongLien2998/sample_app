class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index create new)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.activated.order_desc
                 .page(params[:page]).per Settings.paging.size
  end

  def show
    if @user.activated?
      @microposts = @user.microposts.order_desc.page(params[:page])
                         .per Settings.paging.size
    else
      flash[:danger] = t "global.unactivated"
      redirect_to root_url
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "global.check_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t "global.unsuccessful"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "global.update_success"
      redirect_to @user
    else
      flash.now[:danger] = t "global.update_faild"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "global.delete_user", user_name: @user.name
    else
      flash.now[:danger] = t "destroy_fail", user_name: @user.name
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "global.not_found"
    redirect_to root_url
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "global.not_found"
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "global.not_found"
    redirect_to root_url
  end
end
