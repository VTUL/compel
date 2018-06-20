# -*- coding: utf-8 -*-
require 'rubygems'
require 'nokogiri'
require 'time'

# Code taken and modified from https://github.com/thomasfl/wordpress_import.git
# Parse WordPress xml interchange file format (wxr)

class WordPressComment
  attr_accessor :id, :author, :author_email, :author_url, :author_IP, :date, :date_gmt, :content, :approved, :type, :parent, :user_id, :article_url

  def initialize(options={})
    options.each{|k,v|send("#{k}=",v)}
  end

end

class WordPress

  class Article

    class Metadata
      attr_accessor :views_template, :subtitle, :year_of_composition, :instrumentation, :type_of_electronics,
                    :num_of_channels, :duration, :video_component, :performance_clip, :link_to_score_resources,
                    :link_to_recording

      def initialize(options={})
        options.each{|k,v|send("#{k}=",v)}
      end
    end

    attr_accessor :title, :body, :owner, :status, :url, :filename, :publishedDate, :date, :year, :month, :tags, :picture, :comments, :metadata, :encoded_content 

    def initialize(options={})
      options.each{|k,v|send("#{k}=",v)}
    end

    def to_s
      "#<WordPressArticle "+instance_variables.collect{|var|var+": "+instance_variable_get(var).to_s}.join(",")+">"
    end
  end

  class Author
    attr_accessor :id, :login, :email, :display_name, :first_name, :last_name

    def initialize(options={})
      options.each{|k,v|send("#{k}=",v)}
    end
  end
 
  # Removed garbage created by MS Word.
  def self.removeWordGarbage(html)
    # start by completely removing all unwanted tags
    html = html.gsub(/<[\/]?(font|span|xml|del|ins|[ovwxp]:\w+)[^>]*?>/i, '')
    # then remove unwanted attributes
    html = html.gsub(/ (class|style)="[^"]*"/i,"")
    html = html.gsub("<strong><strong>", "<strong>")
    html = html.gsub("<strong><strong>", "<strong>")
    html = html.gsub("</strong></strong>", "</strong>")
    html = html.gsub("</strong></strong>", "</strong>")
    html = html.gsub("<strong></strong>", "")
    return html
  end

  def self.addParagraphs(body)
    response = ""
    body.split(/\n/).each do |line|
      if(line != "")
        response += "<p>" + line + "</p>\n"
      end
    end
    return response
  end

  # Parse wordpress xml data, yields wp:author objects
  def self.parse_wp_authors(content, &block)
    doc = Nokogiri::XML(content)
    puts "Debug: parse wp:author objects"
    doc.xpath('//wp:author').each do |author|
      id = author.xpath('wp:author_id').first.content.to_s
      login = author.xpath('wp:author_login').first.content.to_s
      email = author.xpath('wp:author_email').first.content.to_s
      display_name = author.xpath('wp:author_display_name').first.content.to_s
      first_name = author.xpath('wp:author_first_name').first.content.to_s
      last_name = author.xpath('wp:author_last_name').first.content.to_s

      wp_author = WordPress::Author.new(id: id,
                                        login: login,
                                        email: email,
                                        display_name: display_name,
                                        first_name: first_name,
                                        last_name: last_name)
      yield wp_author
    end

  end

  # Parse wordpress xml data, yields Article objects
  def self.parse_items(content, &block)
    doc = Nokogiri::XML(content)
    puts "Debug: parse item"
    doc.xpath('//item').each do |article|

      title = article.at('title').content

      encoded_content = article.xpath('content:encoded').first.content.to_s
      body = article.xpath('content:encoded').first.content.to_s
      body = body.gsub(/^(<img [^>]*>)/i,'')  # Remove first img tag

      picture = nil
      if ($1)
        img = $1
        picture = img[/src=\"([^\"]*)\"/i,1] # ...and store img url
        picture = picture.sub(/\?.*$/,'')
      end
      if (picture == nil and body =~ /<a href[^>]*><img .*src[^"]"([^"]*).*<\/a>/i)
        picture = $1
        body = body.sub(/<a href[^>]*><img .*src[^"]"([^"]*).*<\/a>/i,'')
      end

      body = removeWordGarbage(body)
      body = addParagraphs(body)

      owner = article.xpath('dc:creator', 'dc' => "http://purl.org/dc/elements/1.1/").first.content.to_s
      status = article.xpath('wp:status').first.content.to_s
      url =  article.at('link').content
      filename = url[/\/([^\/]*)\/$/,0].to_s.gsub("/","")

      publishedDate = article.at('pubDate').content
      date = Time.parse(publishedDate)
      year = date.year.to_s
      month = date.month.to_s
      if(month.to_i < 10)
        month = "0" + month.to_i.to_s
      end

      tags = []
      article.xpath('category').each do |category|
        if(category['domain'] and category['domain'] == 'category' )
          tags << category.content
        end
      end

      comments = []
      article.xpath('wp:comment').each do |comment|
        if(comment.xpath('wp:comment_approved').text == "1")then
          comment = WordPressComment.new(:author => comment.xpath('wp:comment_author').text,
                                         :author_email =>  comment.xpath('wp:comment_author_email').text,
                                         :content => comment.xpath('wp:comment_content').text,
                                         :date => comment.xpath('wp:comment_date').text,
                                         :date_gmt => comment.xpath('wp:comment_date_gmt').text,
                                         :author_url => comment.xpath('wp:comment_author_url').text,
                                         :author_IP => comment.xpath('wp:comment_author_IP').text )
          comments << comment
        end
      end
 
      article_metadata = Hash.new
      wp_postmeta = article.xpath('wp:postmeta')
      wp_postmeta.each do |metadata|
        key = metadata.xpath('wp:meta_key').first.content.to_s
        value = metadata.xpath('wp:meta_value').first.content.to_s
        article_metadata[key] = value        
      end

      # Do some rudamentary parsing of the instruments if there are no parenthesis in there.
      # NOTE: The Wordpress instrumentation appears to be a single free-form field, 
      #       whereas the COMPEL Instruments are segmented. Because of this, it seems easier to 
      #       leave any instrumentation as is when there are parenthesis,
      #       and potentially leave things up to manual clean up of these entries afterwards 
      #       if there's time.
      instruments = [article_metadata['wpcf-instrumentation']]
      instruments = article_metadata['wpcf-instrumentation'].gsub( ' and ', ',').split(/[,+;&]/) if article_metadata['wpcf-instrumentation'][/\(.*?\)/] == nil
      instruments.map! {|instr| instr.strip} # remove leading/trailing whitespace
      instruments = instruments.reject { |instr| instr.empty? } # remove blank instruments
  
      article_metadata = WordPress::Article::Metadata.new(views_template: article_metadata['_views_template'],
                           subtitle: article_metadata['wpcf-subtitle'],
                           year_of_composition: article_metadata['wpcf-year-of-composition'],
                           instrumentation: instruments, 
                           type_of_electronics: article_metadata['wpcf-type-of-electronics'], 
                           num_of_channels: article_metadata['wpcf-number-of-channels'], 
                           duration: article_metadata['wpcf-length-of-work'],
                           video_component: article_metadata['wpcf-video-component'],
                           performance_clip: article_metadata['wpcf-performance-clip'],
                           link_to_score_resources: article_metadata['wpcf-link-to-score-resources'],
                           link_to_recording: article_metadata['wpcf-link-to-recording'])

      wp_article = WordPress::Article.new(:title => title,
                                          :body => body,
                                          :owner => owner,
                                          :status => status,
                                          :url => url,
                                          :filename => filename,
                                          :publishedDate => publishedDate,
                                          :date => date,
                                          :year => year,
                                          :month => month,
                                          :tags => tags,
                                          :picture => picture,
                                          :comments => comments,
                                          :metadata => article_metadata,
                                          :encoded_content => encoded_content)
      yield wp_article
    end

  end
end
