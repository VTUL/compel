# Generated via
#  `rails generate hyrax:work Performance`
module Hyrax
  class PerformancePresenter < Hyrax::WorkShowPresenter
    delegate :venue, :date, :duration,
             :resource_type, :medium, to: :solr_document
  end
end
