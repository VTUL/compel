# Generated via
#  `rails generate hyrax:work Composition`
module Hyrax
  # Generated controller for Composition
  class CompositionsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    require 'vtul/email_helper'
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

      email_helper = EmailHelper.new
      @creator_emails = email_helper.get_emails(@presenter.creator)
      @contributor_emails = email_helper.get_emails(@presenter.contributor)
    end
  end
end
