require 'open-uri'
require 'net/http'
require 'openssl'

class PexelsApiHandler
  def initialize
    @base_url = 'https://api.pexels.com'
    @api_version = 'v1'
  end

  def searchImageForCountryAndCity(country, city)
    image_url = ""
    api_common_url = "#{@base_url}/#{@api_version}"
    api_url = api_common_url + "/search?query=#{country} #{city}&per_page=1&size=small"
    countrycity_detected_serialized = URI.open(api_url, {"Authorization" => ENV['PEXELS_API_KEY'] }).read
    countrycity_detected = JSON.parse(countrycity_detected_serialized)
    if countrycity_detected["photos"]
      photo = countrycity_detected["photos"].first
      if photo["src"]["small"]
        image_url = photo["src"]["small"]
      end
    end
    image_url
  end
end
