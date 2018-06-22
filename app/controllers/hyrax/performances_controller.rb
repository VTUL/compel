# Generated via
#  `rails generate hyrax:work Performance`
module Hyrax
  # Generated controller for Performance
  class PerformancesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Performance

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::PerformancePresenter

    def new
      curation_concern.contributor = [current_user.user_key]
      super
    end

    def show
      super
      perf = Performance.find(params[:id])
      @composition = perf.composition
      if !@composition.nil?
        @composer_link = "/users/#{@composition.creator.first.gsub('.', '-dot-')}"
      end
    end
  end
end
