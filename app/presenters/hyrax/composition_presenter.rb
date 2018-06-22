# Generated via
#  `rails generate hyrax:work Composition`
module Hyrax
  class CompositionPresenter < Hyrax::WorkShowPresenter
    delegate :duration, :medium, :technical_specs, :program_notes,
             to: :solr_document
  end
end
