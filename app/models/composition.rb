# Generated via
#  `rails generate hyrax:work Composition`
class Composition < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Compel::Metadata

  self.indexer = CompositionIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your composition must have a title.' }
  validates :creator, presence: { message: 'Your composition must have a composer.' }
  validates :subject, presence: { message: 'Your composition must have instruments.' }

  self.human_readable_type = 'Composition'

  has_many :performances

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
