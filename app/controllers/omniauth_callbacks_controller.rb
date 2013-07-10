class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    success
  end

  def linkedin
    success
  end

  private

  def success
    auth_hash = request.env['omniauth.auth']
    @authentication          = Authentication.find_or_initialize_by_uid(auth_hash["uid"])
    @authentication.provider = auth_hash["provider"].downcase
    @authentication.token    = auth_hash["credentials"]["token"]
    @authentication.secret   = auth_hash["credentials"]["secret"]
    @authentication.save

    if current_user
      current_user.authentications << @authentication
      redirect_to "/"
    elsif @authentication.user
      set_flash_message(:notice, :success, kind: auth_hash["provider"])
      sign_in_and_redirect @authentication.user
    else
      session[:authentication_id] = @authentication.id
      session[:name] = auth_hash["info"]["name"]
      session[:email] = auth_hash["info"]["email"]
      redirect_to new_registration_path
    end
  end
end
