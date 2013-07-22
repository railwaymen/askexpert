class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @profile = @user.public_profile
  end

  def search
    @users = User.search{fulltext params[:query]}.results
  end
end
