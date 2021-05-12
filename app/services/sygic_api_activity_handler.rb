require 'json'
require 'open-uri'

require 'amazing_print'

class SygicApiActivityHandler
  def initialize
    @base_url = 'https://api.sygictravelapi.com'
    @api_version = '1.2'
    @api_lang = 'en'
  end

  def searchActivitiesAround(lat, long, km_radius, limit)
    area_param = "area=#{lat},#{long},#{km_radius*1000}"
    api_url = "#{@base_url}/#{@api_version}/#{@api_lang}/places/list?"
    api_url += "#{area_param}&levels=poi&limit=#{limit}"
    pois_detected_serialized = URI.open(api_url, {"x-api-key" => ENV['SYGIC_API_KEY'] }).read
    pois_detected = JSON.parse(pois_detected_serialized)
    pois_detected["data"]["places"].each do |poi|
      # TODO : create Activity
    end
  end

end
