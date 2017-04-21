class HomeController < ApplicationController
  class Form
    include ActiveModel::Model

    attr_accessor :attractions
  end
  def index
    @attractions = Attraction.all
    @form = Form.new(attractions: @attractions)
  end

  def calc

  end
end
