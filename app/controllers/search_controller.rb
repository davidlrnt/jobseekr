class SearchController < ApplicationController

  def index
  end

  def post
    binding.pry
  end


  def new
    ##GETS ZIPCODE || CITY

    zipcode_uri = 'http://maps.googleapis.com/maps/api/geocode/json?'
    api_response = HTTParty.get(zipcode_uri, :query => {:address => params["location"]})
    if params["position"][0].empty? && params["position"].length < 2

      flash[:notice] = "Invalid Job"
      redirect_to root_url
    elsif api_response["results"].empty? && !params["location"].empty?
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
    $globalresults = {}
    params["position"].each do |position|
    i = 1
    $globalresults[:careerbuilder] ||= []

    while i < 5 do
    querycareer =  {:location => loc, :keywords => position, :excludenational => true, :pagenumber => i, :radius => career_radius, :orderby => 'date', :perpage => 50 }
    career_uri = 'http://api.careerbuilder.com/v1/jobsearch?DeveloperKey=WDHV4LR6B3Y8W6T8FGDB'
    cresponse = getDetails(querycareer, career_uri)
    i += 1
    if !cresponse["ResponseJobSearch"]["Results"]
        flash[:notice] = "Invalid Job"
        return redirect_to root_url
    else


        if cresponse["ResponseJobSearch"]["Results"]["JobSearchResult"].is_a?(Hash)
           $globalresults[:careerbuilder] << [cresponse["ResponseJobSearch"]["Results"]["JobSearchResult"]]
        else
           $globalresults[:careerbuilder] << cresponse["ResponseJobSearch"]["Results"]["JobSearchResult"]
        end

    break if i > cresponse["ResponseJobSearch"]["TotalPages"].to_i

    end
    end
    $globalresults[:indeed] ||= []

    i = 1
    while i <= 200 do
    query = {:l => loc, :q => position,:latlong => 1, :v => 2,:start => i, :limit => 25, :sort => 'date', :radius => radius}

    indeed_uri = 'http://api.indeed.com/ads/apisearch?publisher=6706968191689061'
    i += 25
    indexPage = 1
    response = getDetails(query, indeed_uri)
      if !response["response"]["results"]
        flash[:notice] = "Invalid Job"
        return redirect_to root_url
      else

        if response["response"]["results"]["result"].is_a?(Hash)
          $globalresults[:indeed] << [response["response"]["results"]["result"]]
        else
          $globalresults[:indeed] << response["response"]["results"]["result"]
        end
        indexPage += 1
         break if indexPage > response["response"]["pageNumber"].to_i
      end
    end
  end
    @job = Job.new
  end


  end

  def getDetails(query, base_uri)
  api_response = HTTParty.get(base_uri, :query => query)
  end
end


