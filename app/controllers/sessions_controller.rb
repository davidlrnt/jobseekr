class SessionsController < ApplicationController

  def create
    auth = request.env['omniauth.auth']
    @user = User.create_with_omniauth(auth)
    log_in @user
    flash[:notice] = "Hello, #{@user.name}! ♥"
    redirect_to '/'
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
