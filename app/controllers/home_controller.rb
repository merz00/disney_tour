require 'json'

class HomeController < ApplicationController
  def index
    @attractions = Attraction.all
    @areas       = Area.includes(:attractions)
  end

  def calc





    # execute python
    if date_params.sub!(%r{(\d{4})/(\d{2})/(\d{2})}, '\1\2\3') &&
        departed_time_params.sub!(%r{(\d{2}):\d{2}}, '\1')
      system('python', "#{Rails.root.to_s}/lib/others/python/predict_wait_time.py", '20170401', '8', '1')
      logger.info("execute python predict_wait_time.py #{date_params} #{departed_time_params.next} #{weather_state.to_s}")
    end

    hash = {}
    File.open("#{Rails.root.to_s}/lib/others/cpp/sample.json") do |file|
      hash = JSON.load(file)
    end





    @start_info = StartInfo.new.tap do |info|
      info.position_id     = 0
      info.attraction_name = Attraction.find_by(algorithm_id: info.position_id).name
      info.start_datetime  = DateTime.now.to_s(:time)
    end

    @attraction_infos = [1,2,3].map do |i|
      AttractionInfo.new.tap do |info|
        info.algorithm_id    = i
        info.attraction_name = Attraction.find_by(algorithm_id: info.algorithm_id).name
        info.move_time       = 10
        info.arrive_time     = DateTime.now.to_s(:time)
        info.wait_time       = 20
        info.ride_time       = DateTime.now.to_s(:time)
        info.need_time       = 15
        info.end_time        = DateTime.now.to_s(:time)
      end
    end

    # Cをコール
  end

  class StartInfo
    attr_accessor :position_id, :attraction_name, :start_datetime
  end

  class AttractionInfo
    attr_accessor :algorithm_id, :attraction_name, :move_time, :arrive_time, :wait_time, :ride_time, :need_time, :end_time
  end

  private

  def date_params
    params[:departed][:date]
  end

  def departed_time_params
    params[:departed_time]
  end

  def weather_state
    weather_result = WeatherApi.new('Akashi-shi').execute
    case weather_result['list'].first['weather'].first['main']
      when 'Clear'
        '1'
      when 'Clouds'
        '2'
      when 'Rainy'
        '3'
      else
        '5'
    end
  end
end
