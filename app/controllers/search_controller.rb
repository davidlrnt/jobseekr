class SearchController < ApplicationController

  def index
  end


  def new
    ##GETS ZIPCODE || CITY
    zipcode_uri = 'http://maps.googleapis.com/maps/api/geocode/json?'
    api_response = HTTParty.get(zipcode_uri, :query => {:address => params["location"]})

    if api_response["results"].empty? && !params["location"].empty?
      flash[:notice] = "Invalid address"
      redirect_to root_url
    else
      if !params["location"].empty?
      response = api_response["results"][0]["address_components"].select do |hash|
        hash.has_value?(["postal_code"])
      end
    zipcode = response[0]["long_name"] if !response.empty?
    else
    zipcode = HTTParty.get("http://ipinfo.io/json")["postal"]
    end
    loc = zipcode || params["location"]


    params["radius"] == "" ? radius = 5 : radius =  params["radius"]
    if params["radius"] == ""
      career_radius = 5
    elsif params["radius"].to_i <= 7
      career_radius = 5
    elsif params["radius"].to_i <= 15
      career_radius = 10
    else params["radius"].to_i <= 25
      career_radius = 20
    end

    params["position"].delete("")
    @results = {}
    params["position"].each do |position|
    querycareer =  {:location => loc, :keywords => position, :radius => career_radius, :orderby => 'date', :perpage => 50 }
    carrer_uri = 'http://api.careerbuilder.com/v1/jobsearch?DeveloperKey=WDHV4LR6B3Y8W6T8FGDB'
    cresponse = getDetails(querycareer, carrer_uri)
    @results[:careerbuilder] ||= []
    @results[:careerbuilder] << cresponse["ResponseJobSearch"]["Results"]["JobSearchResult"]

    query = {:l => loc, :q => position,:latlong => 1, :v => 2, :limit => 25, :sort => 'date', :radius => radius}
    indeed_uri = 'http://api.indeed.com/ads/apisearch?publisher=6706968191689061'

    response = getDetails(query, indeed_uri)
      if !response["response"]["results"]
        flash[:notice] = "Invalid Job"
        redirect_to root_url
      else
      @results[:indeed] ||= []
      @results[:indeed] << response["response"]["results"]["result"]
      end
    end
    @job = Job.new
  end
  end

  def getDetails(query, base_uri)
  api_response = HTTParty.get(base_uri, :query => query)
  end
end


