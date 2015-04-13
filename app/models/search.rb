class Search

attr_accessor :address, :keywords

  @@googlezip = 'http://maps.googleapis.com/maps/api/geocode/json?'

  def initialize(location, keywords)
    @location = location
    @keywords = keywords
  end


  def get_zipcode
    return auto_zipcode if @location.empty?
    query = {:address => @location}
    api_caller(@@googlezip, query)["results"][0]["address_components"].select do |hash|
        hash.has_value?(["postal_code"])
      end[0]["long_name"]
    # zipcode_uri = 'http://maps.googleapis.com/maps/api/geocode/json?'
    # api_response = HTTParty.get(zipcode_uri, :query => {:address => @location})
  end

  def auto_zipcode
    HTTParty.get("http://ipinfo.io/json")["postal"]
  end

  def api_caller(uri, query)
    HTTParty.get(uri, :query => query)
  end

end
