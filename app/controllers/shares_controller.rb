class SharesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = current_user.visible_posts.find(params[:post_id])
    @share = @post.shares.build(share_params)
    @share.sender = current_user
    if @share.save
      flash[:notice] = "Successfully shared post."
    else
      flash[:error] = "Couldn't share post."
    end
    redirect_to :back
  end

  private

  def share_params
    params.require(:share).permit(:content, :recipient_id)
  end
end
