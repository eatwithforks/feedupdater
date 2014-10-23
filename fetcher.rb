# encoding: utf-8
$:.unshift File.dirname(__FILE__)
require 'rubygems'
require 'mechanize'
require 'pp'
require 'config'
require 'gmail'

updated_counter = 0 # Counter for checking if each iteration has updates
updated_manga = []
List.each do |manga|
  agent = Mechanize.new
  page = agent.get(Targeturl)

  folder = manga.gsub(' ', '_')
  next if agent.page.links.find { |l| l.text.match(/#{manga}.*\s\d/) }.nil?

  results = []
  results = agent.page.links_with(:text => /#{manga}.*\s\d/)
  results.each do |release|
    page = release.click
    next if agent.page.links.find { |l| l.text.match(/#{Nextpage}/) }.nil?

    page.images.each { |e| @metadata = e.url.to_s if e.url.to_s.match(/#{Pictype}/) }
    @chapter = @metadata.split('/')[-2]
    next if Dir.exists?("#{SaveDir}/#{@chapter}")

    images = []
    loop do
      begin
        page.images.each { |e| @image = e.url.to_s if e.url.to_s.match(/#{Pictype}/) }
        images << @image

        next_link = agent.page.link_with(:text => /#{Nextpage}/)
        page = next_link.click
      rescue Mechanize::UnsupportedSchemeError => e
        break
      end
    end

    images.each do |pic|
      begin
        file_name = pic.split('/')[-1]
        img = agent.get(pic)
        img.save "#{SaveDir}/#{@chapter}/#{file_name}"
      rescue Mechanize::ResponseCodeError => e
        break
      end
    end
    updated_counter += 1
    updated_manga << @chapter
  end
end

if updated_counter > 0
  gmail = Gmail.new(GmailUser, GmailPass)
  gmail.deliver do
    to Emailtarget
    subject 'There are new manga updates'
    text_part do
      body updated_manga.join("\n")
    end
  end
  gmail.logout
end