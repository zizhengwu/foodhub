require "gcloud/datastore"

class Restaurant
  def self.dataset
    @dataset ||= Gcloud.datastore(
        Rails.application.config.database_configuration[Rails.env]['dataset_id']
    )
  end

  def self.query options = {}
    query = Gcloud::Datastore::Query.new
    query.kind "Business"
    query.limit options[:limit]   if options[:limit]
    query.cursor options[:cursor] if options[:cursor]

    results = dataset.run query
    restaurants   = results.map {|entity| Book.from_entity entity }

    if options[:limit] && results.size == options[:limit]
      next_cursor = results.cursor
    end

    return restaurants, next_cursor
  end
end
