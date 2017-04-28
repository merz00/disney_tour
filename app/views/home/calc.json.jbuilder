json.start_info do |json|
  json.position_id     @start_info.position_id
  json.attraction_name @start_info.attraction_name
  json.start_datetime  @start_info.start_datetime
end

json.attraction_infos do |json|
  json.array! @attraction_infos do |info|
    json.algorithm_id    info.algorithm_id
    json.attraction_name info.attraction_name
    json.move_time       info.move_time
    json.arrive_time     info.arrive_time
    json.wait_time       info.wait_time
    json.ride_time       info.ride_time
    json.need_time       info.need_time
    json.end_time        info.end_time
  end
end
