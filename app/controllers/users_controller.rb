class UsersController < ApplicationController
 
  def index
    @users = User.all
  end

  def show
    @user = User.find_by :id => params[:id]
    @follows = @user.followed
    @notfollows = User.all - (@follows) - [@user]
    @followers =  @user.followers
    if @user.nil?
      flash[:notice] = "That user does not exist!"
      redirect_to root_url
    end
  end


  # POST /follow
  def follow
    if user_signed_in?
      other_user = User.find_by :id => params[:id]
      Follow.create(:from => current_user, :to => other_user)
      flash[:notice] = "User '" + other_user[:name].to_s + "' followed."
      redirect_to :back
    else
      flash[:notice] = "You cannot follow someone when not logged in."
      redirect_to root_url
    end
  end

  # POST /unfollow
  def unfollow
    if user_signed_in?
      other_user = User.find_by :id => params[:id]
      @f = Follow.find_by(:from => current_user, :to => other_user)
      @f.destroy
      #Follow.destroy_all :from => current_user, :to => other_user
      flash[:notice] = "User '" + other_user[:name].to_s + "' unfollowed."
      redirect_to :back
    else
      flash[:notice] = "You cannot unfollow someone when not logged in."
      redirect_to root_url
    end
  end
end
