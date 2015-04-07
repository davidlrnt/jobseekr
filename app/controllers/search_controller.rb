class SearchController < ApplicationController

  def index
  end


  def new

    ##GETS ZIPCODE || CITY
    zipcode_uri = 'http://maps.googleapis.com/maps/api/geocode/json?'
    api_response = HTTParty.get(zipcode_uri, :query => {:address => params["location"]})
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
    @results << getDetails(query, indeed_uri)["response"]["results"]["result"]
    end
    binding.pry
    @job = Job.new
  end

  def getDetails(query, base_uri)
  api_response = HTTParty.get(base_uri, :query => query)
  end
end


