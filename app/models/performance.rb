# Generated via
#  `rails generate hyrax:work Performance`
class Performance < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Compel::Metadata

  self.indexer = PerformanceIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates :title, presence: { message: 'Your performance must have a title.' }
  validates :contributor, presence: { message: 'Your performance must have a performer.' }
  validates :subject, presence: { message: 'Your performance must have instruments.' }

  self.human_readable_type = 'Performance'

  belongs_to :composition, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
