class JobsController < ApplicationController

  def create
    if logged_in?
      city = City.find_by(name: params["job"]["city"]) || City.create(name: city_params["city"])
      @job = Job.find_by_job_key(job_params["job_key"])
      if @job.nil?
        @job = Job.create(job_params)
        @job.update(city_id: city.id)
        current_user.jobs << @job
      else
        current_user.jobs << @job if !current_user.jobs.include?(@job)
      end

      redirect_to(:back)
    else
      redirect_to '/auth/linkedin'
    end
  end

  def destroy
    @job_user = current_user.job_users.find_by(job_id: params[:job_id])
    @job_user.destroy
    redirect_to(:back)
  end

  private
  # def set_user
  #   @user = User.find(params[:id])
  # end
  def city_params
    params.require(:job).permit(:city)
  end

  def job_params
      params.require(:job).permit(:company, :position, :country, :state, :url, :lat, :long, :job_key,:description, :date_posted)
  end
end
