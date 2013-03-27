class RelationshipsController < ApplicationController
  before_filter :signed_in_user
  
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      # only one line will be invoked here(html/js)
      # Regular web request
      format.html { redirect_to @user }
      # Ajax request. Default will call <action_name>.js.erb (create.js.erb) file
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      # only one line will be invoked here(html/js)
      # Regular web request
      format.html { redirect_to @user }
      # Ajax request. Default will call <action_name>.js.erb (create.js.erb) file
      format.js
    end
  end
end