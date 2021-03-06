require 'gcloud/datastore'
require 'json'

class Restaurant
  attr_accessor :id, :info, :name, :full_address, :categories, :city, :menu

  def initialize
    @menu = []
  end

  def self.dataset
    @dataset ||= Gcloud.datastore(
        Rails.application.config.database_configuration[Rails.env]['dataset_id']
    )
  end

  def self.query options = {}
    query = Gcloud::Datastore::Query.new
    query.kind 'Business'
    # query.limit options[:limit]   if options[:limit]
    # query.cursor options[:cursor] if options[:cursor]

    results = dataset.run query
    restaurants   = results.map {|entity| Restaurant.from_entity entity }

    if options[:limit] && results.size == options[:limit]
      next_cursor = results.cursor
    end

    return restaurants, next_cursor
  end

  def self.retrieve(business_id)

    query = Gcloud::Datastore::Key.new 'Business', business_id
    entry = dataset.lookup query

    from_entity entry.first if entry.any?
  end

  def self.from_entity entity
    restaurant = Restaurant.new
    restaurant.id = entity.key.name
    entity.properties.to_hash.each do |name, value|
      restaurant.send "#{name}=", value
    end
    restaurant_info_hash = JSON.parse(restaurant.info)
    ['name', 'full_address', 'categories', 'city'].each do |attribute|
      restaurant.send "#{attribute}=", restaurant_info_hash[attribute]
    end
    if !restaurant_info_hash['menu'].nil?
      restaurant.menu = restaurant_info_hash['menu']
    end
    restaurant
  end
end
