require 'json'
require 'open-uri'

# Sygic uses OSM format for opening hours
# At some point, we will need to handle this format too
# Here is a link to a js implementation we may use : 'https://github.com/opening-hours/opening_hours.js'

class SygicApiActivityHandler
  def initialize
    @base_url = 'https://api.sygictravelapi.com'
    @api_version = '1.2'
    @api_lang = 'en'
  end

  def searchActivitiesAround(lat, lng, km_radius, limit)
    # Prepare first API call using area in circle of radius in meters around lat, lng point
    # We look for list of places having level 'poi'
    area_param = "area=#{lat},#{lng},#{km_radius*1000}"
    api_common_url = "#{@base_url}/#{@api_version}/#{@api_lang}/places"
    api_url = api_common_url + "/list?#{area_param}&levels=poi&limit=#{limit}"
    pois_detected_serialized = URI.open(api_url, {"x-api-key" => ENV['SYGIC_API_KEY'] }).read
    pois_detected = JSON.parse(pois_detected_serialized)
    # Now, we want to get details on each poi place
    # We should use API endpoint multi place details: (like https://api.sygictravelapi.com/1.2/{{lang}}/places?ids=poi:530|poi:531|poi:532|poi:533)
    # but does not seem to work actually, so we currently use place details endpoint for each
    pois_detected["data"]["places"].each do |poi|
      api_url = api_common_url + "/#{poi["id"]}"
      poi_details_serialized = URI.open(api_url, {"x-api-key" => ENV['SYGIC_API_KEY'] }).read
      poi_details = JSON.parse(poi_details_serialized)
      poi_d = poi_details["data"]["place"]
      # media
      api_media_url = api_url + "/media"
      poi_media_serialized = URI.open(api_media_url, {"x-api-key" => ENV['SYGIC_API_KEY'] }).read
      poi_media = JSON.parse(poi_media_serialized)["data"]["media"]

      photo_url = ""
      if poi_d["thumbnail_url"]
        photo_url = poi_d["thumbnail_url"]
      end
      if poi_media.count > 0 && poi_media.first["url"]
        photo_url = poi_media.first["url"]
      end
      # Retrieve attribution data
      poi_media_attribution = {}
      if poi_media.count > 0 && poi_media.first["attribution"]
        poi_media_attribution = poi_media.first["attribution"]
      end

      # Create Activity if not yet exist, update it otherwise
      activity_params = { 
        name: poi_d["name"],  
        category: "Sygic API",
        api_provider: "SYGIC",
        api_poi: "#{poi_d["id"]}",
        duration: computeDuration(poi_d["duration_estimate"]),
        description: poi_d["description"] ? "#{poi_d["description"]["text"]}" : "",
        rating: "#{poi_d["rating_local"]}",
        address: "#{poi_d["address"]}",
        latitude: "#{poi_d["location"]["lat"]}",
        longitude: "#{poi_d["location"]["lng"]}",
        photo_title: photo_url,
        api_attributions: {"#{photo_url}" => poi_media_attribution },
        opening_hours: {
          osm_raw: poi_d["opening_hours_raw"] ? "#{poi_d["opening_hours_raw"]}" : "24/7"
        }
      }
      db_activity = Activity.where(["api_provider = ? and api_poi = ?", "SYGIC", "#{poi_d["id"]}"])
      if db_activity.empty?
        Activity.create(activity_params)
      else
        db_activity.update(activity_params)
      end
    end
  end

  def searchImageForCountry(country)
    image_url = ""
    api_common_url = "#{@base_url}/#{@api_version}/#{@api_lang}/places"
    api_url = api_common_url + "/list?query=#{country}&levels=country"
    country_detected_serialized = URI.open(api_url, {"x-api-key" => ENV['SYGIC_API_KEY'] }).read
    country_detected = JSON.parse(country_detected_serialized)
    if country_detected["data"]["places"]
      country_id = country_detected["data"]["places"].first["id"]
      api_url = api_common_url + "/#{country_id}"
      # media
      api_media_url = api_url + "/media"
      media_serialized = URI.open(api_media_url, {"x-api-key" => ENV['SYGIC_API_KEY'] }).read
      media = JSON.parse(media_serialized)["data"]["media"]
      if media.count > 0 && media.first["url"]
        image_url = media.first["url"]
      end
    end
    image_url
  end

  private
  def computeDuration(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end
end
