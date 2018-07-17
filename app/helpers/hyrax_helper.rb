module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def link_to_html_trunc(field, show_link = true)
    link_to_html(field, show_link, true)
  end

  def link_to_html(field, show_link = true, truncate = false)
    if field.is_a? Hash
      options = field[:config].separator_options || {}
      text = field[:value].to_sentence(options)
    else
      text = field
    end

    text = Loofah.fragment(text).scrub!(:whitewash).to_s
    text = truncate(text, length: 100, separator: ' ', escape: false) if truncate

    # this block is only executed when a link is inserted;
    # if we pass text containing no links, it just returns text.
    auto_link(text.html_safe) do |value|
      "<span class='glyphicon glyphicon-new-window'></span>#{('&nbsp;' + value) if show_link}"
    end
  end
end
