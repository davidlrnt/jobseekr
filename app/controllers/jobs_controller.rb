class JobsController < ApplicationController

  def create
    # city = City.create(name: params["job"]["city"])
    city = City.find_by(name: params["job"]["city"]) || City.create(name: params["job"]["city"])
    @job = Job.create(job_params)
    @job.update(city_id: city.id)
    current_user.jobs << @job
    binding.pry
    redirect_to(:back)

  end


  private
  # def set_user
  #   @user = User.find(params[:id])
  # end
  def job_params
      params.require(:job).permit(:company, :position, :country, :state, :url, :lat, :long, :job_key,:description, :date_posted)
  end
end
