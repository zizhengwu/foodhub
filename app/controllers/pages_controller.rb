require 'gcloud/datastore'

class PagesController < ApplicationController
  def home
    @grettings = 'hello world'
  end
end
