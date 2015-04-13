class Search

attr_accessor :address, :keywords

  @@googlezip = 'http://maps.googleapis.com/maps/api/geocode/json?'

  def initialize(location, keywords)
    @location ||= get_location(location)
    @keywords = keywords
  end

  def get_location(location)
    if location.empty?
      auto_zipcode
    else
      get_zipcode(location)
    end
  end

  def get_zipcode(location)
    query = {:address => location}
    results = api_caller(@@googlezip, query)["results"]
    if results.empty?
      "Invalid Location"
    elsif results[0]["address_components"].any? { |hash| hash.has_value?(["postal_code"]) }
      results[0]["address_components"].select do |hash|
        hash.has_value?(["postal_code"])
      end[0]["long_name"]
    else
      location
    end
  end

  def auto_zipcode
    HTTParty.get("http://ipinfo.io/json")["postal"]
  end

  def api_caller(uri, query)
    HTTParty.get(uri, :query => query)
  end

end
