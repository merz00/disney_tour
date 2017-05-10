require 'json'
require 'open-uri'

class WeatherApi
  BASE_URL = 'http://api.openweathermap.org/data/2.5/forecast'
  API_KEY = 'YOUR API KEY'


  def initialize(cityname)
    @url = "#{BASE_URL}?q=#{cityname},jp&APPID=#{API_KEY}"
  end

  def execute
    response = open(BASE_URL + "?q=Akashi-shi,jp&APPID=#{API_KEY}")
    JSON.pretty_generate(JSON.parse(response.read))
  end
end