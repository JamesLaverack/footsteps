class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by :id => params[:id]
    @follows = @user.followed.to_a
    @notfollows = Follow.where.not(:from => params[:id])
    @followers = @user.followers.to_a
    if @user.nil?
      flash[:notice] = "That user does not exist!"
      redirect_to root_url
    end
  end


  # POST /follows
  def follow
    if user_signed_in?
      other_user = User.find_by :id => params[:id]
      Follow.create(:from => current_user, :to => other_user)
    else
      flash[:notice] = "You cannot follow someone when not logged in."
      redirect_to root_url
    end
  end

  def unfollow
    if user_signed_in?
      other_user = User.find_by :id => params[:id]
      Follow.destroy_all :from => current_user, :to => other_user 
    else
      flash[:notice] = "You cannot unfollow someone when not logged in."
      redirect_to root_url
    end
  end
end
