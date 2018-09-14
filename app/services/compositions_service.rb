module CompositionsService

  def self.select_all_options
    repository = CatalogController.new.repository
    builder = CompositionSearchBuilder.new(repository)
    response = repository.search(builder)
    if response.documents.respond_to?("map")
      response.documents.map do |composition|
        [label(composition), composition.id]
      end
    end
  end

  def self.label(composition)
    "#{composition.title.first} | #{composition.creator.first}"
  end

end

