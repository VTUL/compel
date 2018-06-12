# Attempting to override from Hyrax Gem 2.0.0:
#   Hyrax::HomepageController

module Hyrax
  module HomepageControllerOverride
    def index
      super
      images = Dir.entries(Rails.root.join('app/assets/images/vtul/carousel/')).select {|f| !File.directory? f}
      @images = images.shuffle[0..(images.length)].map { |img| 'vtul/carousel/' + img.to_s }
    end
  end
end
