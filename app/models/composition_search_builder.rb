class CompositionSearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include Hydra::AccessControlsEnforcement
  include Hyrax::SearchFilters

  self.default_processor_chain = [:compositions]

  def compositions(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "{!field f=has_model_ssim v=Composition}"
    solr_parameters[:rows] = 10000
  end

end
