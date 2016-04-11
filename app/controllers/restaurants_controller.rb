require 'gcloud/datastore'

class RestaurantsController < ApplicationController

  PER_PAGE = 10

  def index
    @restaurants, @cursor = Restaurant.query limit: PER_PAGE, cursor: params[:cursor]
  end

  def show
    @restaurant = Restaurant.retrieve(params[:id])
  end


  def search
    @reviews = Review.search_by_keyword(params[:q])
    @restaurants = []
    @reviews.each do |review|
      @restaurants.append(Restaurant.retrieve(review.businessId))
    end
  end
end
