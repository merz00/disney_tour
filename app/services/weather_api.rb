require 'json'
require 'open-uri'

class WeatherApi
  BASE_URL = 'http://api.openweathermap.org/data/2.5/forecast'
  API_KEY = ENV['OPEN_WEATHER_API']


  def initialize(cityname)
    @url = "#{BASE_URL}?q=#{cityname},jp&APPID=#{API_KEY}"
  end

  def execute
    response = open(@url)
    JSON.parse(response.read)
  end
end