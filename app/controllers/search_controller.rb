class SearchController < ApplicationController

  def index
  end


  def new

    ##GETS ZIPCODE || CITY
    zipcode_uri = 'http://maps.googleapis.com/maps/api/geocode/json?'
    api_response = HTTParty.get(zipcode_uri, :query => {:address => params["location"]})
    # binding.pry
    if api_response["results"].empty?
      binding.pry
      flash[:notice] = "Invalid address"
      redirect_to root_url
    else

    response = api_response["results"][0]["address_components"].select do |hash|
      hash.has_value?(["postal_code"])
    end
    zipcode = response[0]["long_name"] if !response.empty?
    loc = zipcode || params["location"]


    params["radius"] == "" ? radius = 5 : radius =  params["radius"]
    params["position"].delete("")
    @results = []
    params["position"].each do |position|
    query = {:l => loc, :q => position,:latlong => 1, :v => 2, :limit => 25, :radius => radius}
    indeed_uri = 'http://api.indeed.com/ads/apisearch?publisher=6706968191689061'

    response = getDetails(query, indeed_uri)
      if !response["response"]["results"]
        flash[:notice] = "Invalid Job"
        redirect_to root_url
      else
      @results << response["response"]["results"]["result"]
      end
    end
    @job = Job.new
  end
  end

  def getDetails(query, base_uri)
  api_response = HTTParty.get(base_uri, :query => query)
  end
end


