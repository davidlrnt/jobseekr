class JobsController < ApplicationController

  def new
    @job = Job.new
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

      @job = Job.new
      render 'search/new'
    else
      redirect_to '/auth/linkedin'
    end
  end

  def post
   location = params[:street_address] + " " + params[:city] + " " + params[:state]
   zipcode_uri = 'http://maps.googleapis.com/maps/api/geocode/json?'
   api_response = HTTParty.get(zipcode_uri, :query => {:address => location})
   if api_response["results"].count > 0
     @job = Job.create(post_job_params)
     city = City.find_by(name: params["city"]) || City.create(name: params["city"])
     lat = api_response["results"].first["geometry"]["location"]["lat"]
     lng = api_response["results"].first["geometry"]["location"]["lng"]
     @job.update(country: params[:country], state: params[:state], date_posted: Date.today, job_key: @job.id, creator_id: current_user.id, city_id: city.id.to_i, lat: lat, long: lng)
   else
     flash[:notice] = "Invalid Job or location"
     return redirect_to new_job_path
   end
   redirect_to "/users/#{current_user.id}"
 end

  def destroy
   @job_user = current_user.job_users.find_by(job_id: params[:job_id])
   @job_user.destroy
   redirect_to(:back)
 end

 def delete_job
    @job = Job.find_by(id: params[:job_id])
    @job.delete
    redirect_to(:back)
 end

  def update
    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: 'Post was successfully created.' }
        format.json { render action: 'search/new', status: :created, location: @job }
      else
        format.html { redirect_to '/auth/linkedin' }
      end
    end
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
