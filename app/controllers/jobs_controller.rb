class JobsController < ApplicationController

  def new
  end

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

  def post
    @job = Job.create(post_job_params)
    location = params[:street_address] + " " + params[:city]
    zipcode_uri = 'http://maps.googleapis.com/maps/api/geocode/json?'
    api_response = HTTParty.get(zipcode_uri, :query => {:address => location})

    city = City.find_by(name: params["city"]) || City.create(name: params["city"])
    lat = api_response["results"].first["geometry"]["location"]["lat"]
    lng = api_response["results"].first["geometry"]["location"]["lng"]



    @job.update(country: params[:country], state: params[:state], date_posted: Date.today, job_key: @job.id, created?: true, city_id: city.id.to_i, lat: lat, long: lng)









  end


  private
  # def set_user
  #   @user = User.find(params[:id])
  # end
  def city_params
    params.require(:job).permit(:city)
  end

  def post_job_params
    params.permit(:company, :position, :description, :url)
  end

  def job_params
      params.require(:job).permit(:company, :position, :country, :state, :url, :lat, :long, :job_key,:description, :date_posted)
  end

end
