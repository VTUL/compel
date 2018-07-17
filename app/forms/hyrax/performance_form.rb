# Generated via
#  `rails generate hyrax:work Performance`
module Hyrax
  # Generated form for Performance
  class PerformanceForm < Hyrax::Forms::WorkForm
    self.model_class = ::Performance
    self.terms += [:composition_id, :venue, :date, :duration,
                   :resource_type, :medium, :related_url]

    self.required_fields = [:title, :subject, :creator, 
                            :contributor]

    # composer, title, venue, date of performance, 
    # date of composition creation, performers, 
    # composition, instruments, description, duration,
    # tags, genre, medium 
    def primary_terms
      [:creator, :title, :subject, :contributor, :venue, :date, :date_created,
       :composition_id, :description, :duration, :keyword,
       :resource_type, :medium, :related_url]
    end
    
    # Fields that are automatically drawn on the page below the fold
    def secondary_terms
      []
    end
  end
end
