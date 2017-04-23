class HomeController < ApplicationController
  def index
    @attractions = Attraction.all
  end

  def calc
    @start_info = StartInfo.new.tap do |info|
      info.position_id = 0
      info.start_datetime = DateTime.now
    end

    @attraction_infos = [1,2,3].map do |i|
      AttractionInfo.new.tap do |info|
        info.algorithm_id = i
        info.move_time   = 10
        info.arrive_time = DateTime.now
        info.wait_time   = 20
        info.ride_time   = DateTime.now
        info.need_time   = 15
        info.end_time    = DateTime.now
      end
    end

    # Cをコール
  end

  class StartInfo
    attr_accessor :position_id, :start_datetime
  end

  class AttractionInfo
    attr_accessor :algorithm_id, :move_time, :arrive_time, :wait_time, :ride_time, :need_time, :end_time
  end
end
