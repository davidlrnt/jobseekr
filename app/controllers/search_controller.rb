class SearchController < ApplicationController

  def index
  end

  def new
    base_uri = 'http://maps.googleapis.com/maps/api/geocode/json?'
    api_response = HTTParty.get(base_uri, :query => {:address => params["location"]})
    response = api_response["results"][0]["address_components"].select do |hash|
      hash.has_value?(["postal_code"])
    end
    zipcode = response[0]["long_name"] if response
    loc = zipcode || params["location"]
    query = {:l => loc, :q => params["position"],:latlong => 1, :v => 2, :limit => 25}
    @results = getDetails(query)["response"]["results"]["result"]
    @job = Job.new
  end

  def getDetails(query)
  base_uri = 'http://api.indeed.com/ads/apisearch?publisher=6706968191689061'
  api_response = HTTParty.get(base_uri, :query => query)
  end
end
