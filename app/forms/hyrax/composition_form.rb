# Generated via
#  `rails generate hyrax:work Composition`
module Hyrax
  # Generated form for Composition
  class CompositionForm < Hyrax::Forms::WorkForm
    self.model_class = ::Composition
    self.terms += [:duration, :medium, :resource_type,
                   :technical_specs, :program_notes]

    self.required_fields = [:title, :subject]

    # composer, title, instruments, description, tags,
    # genre, date_created, duration, score, program_notes,
    # technical specs  
    def primary_terms
      [:creator, :title, :subject, :description, :keyword, 
       :resource_type, :date_created, :duration, :medium,
       :source, :technical_specs, :program_notes]
    end

    def secondary_terms
      []
    end
  end
end
