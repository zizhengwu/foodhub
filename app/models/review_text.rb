require 'gcloud/datastore'

class ReviewText
  attr_accessor :id, :text, :info, :businessId

  def self.dataset
    @dataset ||= Gcloud.datastore(
        Rails.application.config.database_configuration[Rails.env]['dataset_id']
    )
  end

  def self.search_by_business(business_id)
    query = Gcloud::Datastore::Query.new
    query.kind 'Review'
    query.where('businessId', '=', business_id)

    results = dataset.run query
    reviews   = results.map {|entity| ReviewText.from_entity entity }

    return reviews
  end

  def self.from_entity entity
    review = ReviewText.new
    review.id = entity.key.name
    entity.properties.to_hash.each do |name, value|
      review.send "#{name}=", value
    end
    review.text = JSON.parse(review.info)['text']
    review
  end

end