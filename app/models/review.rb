require 'gcloud/datastore'

class Review
  attr_accessor :id, :businessId, :keyword, :negative, :neutral, :positive

  def self.dataset
    @dataset ||= Gcloud.datastore(
        Rails.application.config.database_configuration[Rails.env]['dataset_id']
    )
  end

  def self.search_by_keyword(keyword)
    query = Gcloud::Datastore::Query.new
    query.kind 'Keyword'
    query.where('keyword', '=', keyword)

    results = dataset.run query
    reviews   = results.map {|entity| Review.from_entity entity }

    reviews.sort_by! do |review|
      -review.positive
    end

    return reviews
  end

  def self.from_entity entity
    review = Review.new
    review.id = entity.key.name
    entity.properties.to_hash.each do |name, value|
      review.send "#{name}=", value
    end
    review
  end
end