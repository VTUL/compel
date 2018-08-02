module Hyrax
  module Renderers
    class MarkdownGeneratedAttributeRenderer < AttributeRenderer
      include HyraxHelper 

      private

        def li_value(value)
          link_to_html(value)
        end
    end
  end
end
