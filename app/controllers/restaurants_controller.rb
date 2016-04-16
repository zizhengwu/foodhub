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
    @food = params[:q]
    @reviews = Review.search_by_keyword(@food.downcase)
    @restaurants = []
    threads = []
    @reviews.each do |review|
      threads << Thread.new do
        @restaurants.append(Restaurant.retrieve(review.businessId))
      end
    end
    threads.map(&:join)
  end
end
