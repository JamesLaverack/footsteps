class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by :id => params[:id]
    @follows = Follow.find_by :from => params[:id]
    @followers = Follow.find_by :to => params[:id]
    if @user.nil?
      flash[:notice] = "That user does not exist!"
      redirect_to root_url
    end
  end
end
