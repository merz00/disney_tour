require 'json'

class HomeController < ApplicationController
  def index
    @attractions = Attraction.all
    @areas       = Area.includes(:attractions)
  end

  def calc


    hash = {}
    File.open("#{Rails.root.to_s}/lib/others/cpp/sample.txt") do |file|
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
end
