module RelationshipsHelper
  def unfollow
    current_user.active_relationships.find_by followed_id: @user.id
  end

  def follow
    current_user.active_relationships.build
  end
end
