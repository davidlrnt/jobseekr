class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = User.all
  end

  def show
  end

  def edit
    #edit job applied by the current user
    @job_user = current_user.job_users.find_by_job_id(params[:job_id])
    @job_user.update(applied: true)
    redirect_to user_path
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


private
  def set_user
    @user = User.find(params[:id])
  end
  def user_params
      params.require(:user).permit(:name, :email)
  end
end
