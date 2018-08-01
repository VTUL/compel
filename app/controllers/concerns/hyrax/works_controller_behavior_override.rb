module Hyrax
  module WorksControllerBehaviorOverride



    # Finds a solr document matching the id and sets @presenter
    # @raise CanCan::AccessDenied if the document is not found or the user doesn't have access to it.
    def show
      @user_collections = user_collections
      @audio_files = []
      @audio_presenter = nil
      presenter.file_set_presenters.each do |file_set_presenter|
        if file_set_presenter.audio?
      	  @audio_files << {name: file_set_presenter.link_name, id: file_set_presenter.id}
          @audio_presenter = file_set_presenter if @audio_presenter.nil?
        end
      end
      respond_to do |wants|
        wants.html { presenter && parent_presenter }
        wants.json do
          # load and authorize @curation_concern manually because it's skipped for html
          @curation_concern = _curation_concern_type.find(params[:id]) unless curation_concern
          authorize! :show, @curation_concern
          render :show, status: :ok
        end
        additional_response_formats(wants)
        wants.ttl do
          render body: presenter.export_as_ttl, content_type: 'text/turtle'
        end
        wants.jsonld do
          render body: presenter.export_as_jsonld, content_type: 'application/ld+json'
        end
        wants.nt do
          render body: presenter.export_as_nt, content_type: 'application/n-triples'
        end
      end
    end

  end
end
