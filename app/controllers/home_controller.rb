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
    binding.pry

    # 予測分布を呼ぶ
    # Cをコール



  end
end
