# Generated via
#  `rails generate hyrax:work Performance`
module Hyrax
  # Generated form for Performance
  class PerformanceForm < Hyrax::Forms::WorkForm
    self.model_class = ::Performance
    self.terms += [:composition_id, :venue, :date, :duration,
                   :resource_type, :medium]

    self.required_fields = [:title, :subject]

    # composer, title, venue, date of performance, 
    # date of composition creation, performers, 
    # composition, instruments, description, duration,
    # tags, genre, medium 
    def primary_terms
      [:creator, :title, :venue, :date, :date_created, :contributor,
       :composition_id, :subject, :description, :duration, :keyword,
       :resource_type, :medium]
    end
    
    # Fields that are automatically drawn on the page below the fold
    def secondary_terms
      []
    end
  end
end
