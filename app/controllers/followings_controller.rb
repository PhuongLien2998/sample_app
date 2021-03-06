class FollowingsController < ApplicationController
  before_action :logged_in_user, :load_user

  def index
    @title = t "global.following"
    @users = @user.following.order_desc.page(params[:page])
                  .per Settings.paging.size
    render "users/show_follow"
  end
end
