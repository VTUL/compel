module Compel
  module Metadata
    extend ActiveSupport::Concern

    included do
      # date of composition creation
      property :date, predicate: ::RDF::Vocab::DC11.date, multiple: false do |index|
        index.as :stored_searchable, :stored_sortable
      end
      # Duration
      property :duration, predicate: ::RDF::Vocab::DC.extent, multiple: false do |index|
        index.as :stored_searchable
      end
      property :venue, predicate: ::RDF::Vocab::DC.Location do |index|
        index.as :stored_searchable, :facetable
      end
      # fixed media, interactive
      property :medium, predicate: ::RDF::Vocab::DC.medium do |index|
        index.as :stored_searchable
      end
      property :technical_specs, predicate: ::RDF::URI.new('http://purl.org/dc/terms/description#spec'), multiple: false do |index|
        index.type :text
        index.as :stored_searchable
      end
      property :program_notes, predicate: ::RDF::URI.new('http://purl.org/dc/terms/description#note'), multiple: false do |index|
        index.type :text
        index.as :stored_searchable
      end
    end
  end
end
