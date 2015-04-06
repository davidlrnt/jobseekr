class SearchController < ApplicationController

  def index
  end

  def new
    query = {:l => params["location"], :q => params["position"],:latlong => 1, :v => 2}
    @results = getDetails(query)["response"]["results"]["result"]
    @job = Job.new
  end

  def getDetails(query)
  base_uri = 'http://api.indeed.com/ads/apisearch?publisher=6706968191689061'
  api_response = HTTParty.get(base_uri, :query => query)
  end
end
