require 'gcloud/datastore'

class RestaurantsController < ApplicationController

  PER_PAGE = 10

  def index
    @restaurants, @cursor = Restaurant.query limit: PER_PAGE, cursor: params[:cursor]
  end

  def show

  end


  def search

  end
end
