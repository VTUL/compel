module Hyrax
  module Renderers
    class EmailFacetedAttributeRenderer < AttributeRenderer
      private

        def li_value(value)
          search_link = link_to(ERB::Util.h(value), search_path(value))
          email_link = ""
          if !options[:emails][value].nil?
            email_link = mail_to(options[:emails][value], "| <i class='fa fa-envelope'></i>".html_safe)
          end
          return "#{search_link} #{email_link}".html_safe
        end

        def search_path(value)
          Rails.application.routes.url_helpers.search_catalog_path(:"f[#{search_field}][]" => value, locale: I18n.locale)
        end

        def search_field
          ERB::Util.h(Solrizer.solr_name(options.fetch(:search_field, field), :facetable, type: :string))
        end

    end
  end
end
