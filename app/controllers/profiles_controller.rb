class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @profile = current_user.public_profile
  end

  def update
    @profile = current_user.public_profile

    if @profile.update_attributes(profile_params)
      redirect_to root_path, notice: "Profile was successfully updated."
    else
      render "edit"
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:email, :name, :summary, :location, :tag_list)
  end
end
