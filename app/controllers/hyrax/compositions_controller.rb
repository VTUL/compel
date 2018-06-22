# Generated via
#  `rails generate hyrax:work Composition`
module Hyrax
  # Generated controller for Composition
  class CompositionsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Composition

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::CompositionPresenter

    def new
      curation_concern.creator = [current_user.user_key]
      super
    end

    def show
      super
      comp = Composition.find(params[:id])
      @performances = comp.performances
    end
  end
end
