class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @profile = @user.public_profile
  end

  def search
    @users = User.search{fulltext params[:query]}.results
  end

  def subscribe
    @user = User.find(params[:id])
    if current_user.subscribe(@user)
      flash[:notice] = "Successfully subscribed user."
    else
      flash[:error] = "Couldn't subscribe user."
    end
    redirect_to root_path
  end
end
