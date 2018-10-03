require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Compel
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Overrides
    config.to_prepare do
      Hyrax::HomepageController.prepend Hyrax::HomepageControllerOverride
      Hyrax::Dashboard::ProfilesController.prepend Hyrax::Dashboard::ProfilesControllerOverride
      Hyrax::PagesController.prepend Hyrax::PagesControllerOverride
      MultiValueInput.prepend MultiValueInputOverride
      Hyrax::WorksControllerBehavior.prepend Hyrax::WorksControllerBehaviorOverride
    end
  end
end
