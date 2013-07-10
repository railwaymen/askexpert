class RegistrationsController < ApplicationController
  layout "unauthenticated"

  def new
    @user = User.new(email: session[:email], name: session[:name])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      if session[:authentication_id]
        auth = Authentication.find(session[:authentication_id])
        auth.user = @user
        auth.save
        session[:authentication_id] = session[:email] = session[:name] = nil
      end
      sign_in(@user)
      redirect_to "/"
    else
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end