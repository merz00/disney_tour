module AttractionHelper
  def in_area(attractions, area_id)
    attractions.select do |attraction|
      yield attraction if attraction.area_id == area_id
    end
  end
end