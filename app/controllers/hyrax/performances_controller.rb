# Generated via
#  `rails generate hyrax:work Performance`
module Hyrax
  # Generated controller for Performance
  class PerformancesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    require 'vtul/email_helper'
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
      email_helper = EmailHelper.new
      @creator_emails = email_helper.get_emails(@presenter.creator)
      @contributor_emails = email_helper.get_emails(@presenter.contributor)
    end

  end
end
