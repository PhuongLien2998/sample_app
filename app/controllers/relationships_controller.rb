class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: :create
  before_action :find_relationship, only: :destroy

  def create
    current_user.follow @user
    following_error
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow @user
    unfollow_error
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def find_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t "global.not_found"
    redirect_to root_url
  end

  def find_relationship
    @relationship = Relationship.find_by id: params[:id]
    return if @relationship

    flash[:danger] = t "global.relationships_fail"
    redirect_to root_url
  end

  def following_error
    @error = t "global.follow_faild" unless current_user.following? @user
  end

  def unfollow_error
    @error = t "global.unfollow_faild" if current_user.following? @user
  end
end
