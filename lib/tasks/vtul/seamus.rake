# Based on: https://github.com/thomasfl/wordpress_import
require 'tasks/vtul/wordpress_import'

namespace :seamus do

  desc 'Import SEAMUS XML - Authors. To run: bin/rake seamus:extract_authors["input.xml"]'
  task :extract_authors, [:xml_file] => :environment do |task, args|
    begin
      xml_file = args.xml_file
    
      puts "Attempting to read input xml file: " + xml_file

      content = ""
      open(xml_file) do |s| content = s.read end

      wp_authors = Hash.new
      WordPress.parse_wp_authors(content) do | wp_author |
        wp_authors[wp_author.id] = wp_author
      end

      wp_authors.each do | key, wp_author |
        puts "----"
        puts "Key: " + key
        puts "Author ID: " + wp_author.id
        puts "Author Login: " + wp_author.login
        puts "Author Email: " + wp_author.email
        puts "Author Display Name: " + wp_author.display_name
        puts "Author First Name: " + wp_author.first_name
        puts "Author Last Name: " + wp_author.last_name
      end
    rescue Errno::ENOENT => e
      puts "Input XML File is not valid for this task: ["+xml_file+"]" 
      puts 'To run: bin/rake seamus:extract_authors["input.xml"]'
    rescue TypeError => e
      puts 'To run: bin/rake seamus:extract_authors["input.xml"]'
    end
  end

  desc 'Import SEAMUS XML - Items. To run: bin/rake seamus:extract_items["input.xml"]'
  task :extract_items, [:xml_file] => :environment do |task, args|
    begin
      xml_file = args.xml_file

      puts "Attempting to read input xml file: " + xml_file

      content = ""
      open(xml_file) do |s| content = s.read end

      wp_authors = Hash.new
      WordPress.parse_wp_authors(content) do | wp_author |
        wp_authors[wp_author.login] = wp_author
      end

      WordPress.parse_items(content) do | article |
        puts "----"
        puts "Title: " + article.title

        owner = wp_authors[article.owner]
        printf "Owner: %s (%s - %s, %s)\n", owner.login, owner.email, owner.last_name, owner.first_name

        puts "Status: " + article.status
        puts "URL: " + article.url
        puts "Filename: " + article.filename
        puts "Published Date: " + article.publishedDate
        puts "Tags: " + article.tags.to_s
        puts article.body

        puts "Metadata: "
        puts "-- Views Template: " + article.metadata.views_template
        puts "-- Subtitle: " + article.metadata.subtitle
        puts "-- Year of Composition: " + article.metadata.year_of_composition
        puts "-- Instrumentation: " + article.metadata.instrumentation
        puts "-- Type of Electronics: " + article.metadata.type_of_electronics
        puts "-- Num of Channels: " + article.metadata.num_of_channels
        puts "-- Duration: " + article.metadata.duration
        puts "-- Video Component: " + article.metadata.video_component
        puts "-- Performance Clip: " + article.metadata.performance_clip
        puts "-- Link to Score Resources: " + article.metadata.link_to_score_resources
        puts "-- Link to Recording: " + article.metadata.link_to_recording
        puts
      end
    rescue Errno::ENOENT => e
      puts "Input XML File is not valid for this task: ["+xml_file+"]"
      puts 'To run: bin/rake seamus:extract_items["input.xml"]'
    rescue TypeError => e
      puts 'To run: bin/rake seamus:extract_items["input.xml"]'
      puts e
    end
  end
end
