class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  before_action :build_micropost, only: :create

  def create
    if @micropost.save
      flash[:success] = t "global.micropost_created"
      redirect_to root_url
    else
      flash.now[:danger] = t "global.create_failed"
      @feed_items = current_user.feed.order_desc.page(params[:page])
                                .per Settings.paging.size
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "global.micropost_deleted"
    else
      flash[:danger] = t "global.delete_failed"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PARAMS
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url if @micropost.blank?
  end

  def build_micropost
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
  end
end
