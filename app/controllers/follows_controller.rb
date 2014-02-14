class FollowsController < ApplicationController
  before_action :set_follow, only: [:show, :edit, :update, :destroy]


  # POST /follows
  # POST /follows.json
  def create
    @follow = Follow.new(follow_params)

    respond_to do |format|
      if @follow.save
        format.html { redirect_to @follow, notice: 'Follow was successfully created.' }
        format.json { render action: 'show', status: :created, location: @follow }
      else
        format.html { render action: 'new' }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /follows/1
  # DELETE /follows/1.json
  def destroy
    @follow.destroy
    respond_to do |format|
      format.html { redirect_to follows_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_follow
      @follow = Follow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def follow_params
      params.require(:follow).permit(:from, :to)
    end
end
