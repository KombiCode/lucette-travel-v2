require 'uri'
require 'net/http'
require 'openssl'

class FoursquareApiHandler
  def initialize
    @base_url = 'https://api.foursquare.com'
    @api_version = 'v2'
    @api_lang = 'en'
  end

  def searchActivitiesAround(lat, lng, km_radius, limit)
    # Prepare first API call using area in circle of radius in meters around lat, lng point
    # We look for list of places having level 'poi'
    api_version_param = "v=20211216"
    area_param = "ll=#{lat},#{lng}&radius=#{km_radius*1000}"
    api_common_url = "#{@base_url}/#{@api_version}/venues"
    api_credentials = "client_id=#{ENV['FOURSQUARE_API_CLIENT_ID']}&client_secret=#{ENV['FOURSQUARE_API_CLIENT_SECRET']}"
    api_url = api_common_url + "/explore?#{api_credentials}&#{area_param}&limit=#{limit}&#{api_version_param}"
    api_response_serialized = URI.open(api_url).read
    api_response = JSON.parse(api_response_serialized)
    pois_ids_array = api_response["response"]["groups"][0]["items"].collect { |item| item["venue"]["id"]}

    # Now, we want to get details on each poi place
    pois_ids_array.each do |id|
      api_url = api_common_url + "/#{id}" + "?#{api_credentials}&#{api_version_param}"
      pois_details_serialized = URI.open(api_url).read
      pois_details = JSON.parse(pois_details_serialized)

      venue = pois_details["response"]["venue"]
      name = venue["name"]
      address = venue["location"]["formattedAddress"]
      latitude = venue["location"]["lat"]
      longitude = venue["location"]["lng"]
      rating = venue["rating"]
      photo = venue["bestPhoto"]
      photo_title = photo["prefix"] + "original" + photo["suffix"]

      # Create Activity if not yet exist, update it otherwise
      activity_params = { 
        name: name,  
        category: "Foursquare API",
        api_provider: "FOURSQUARE",
        api_poi: id,
        duration: computeDuration(3600),
        description: "",
        rating: rating/2,
        address: address,
        latitude: latitude,
        longitude: longitude,
        photo_title: photo_title,
        api_attributions: {"#{photo_title}" => {}},
        opening_hours: { osm_raw: "24/7" }
      }
      db_activity = Activity.where(["api_provider = ? and api_poi = ?", "FOURSQUARE", "#{id}"])
      if db_activity.empty?
        Activity.create(activity_params)
      else
        db_activity.update(activity_params)
      end
    end

  end

  def searchImageForCountry(country)
    image_url = ""
  end

  private
  
  def computeDuration(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end
end
