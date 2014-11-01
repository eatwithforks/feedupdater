# encoding: utf-8
require 'rubygems'
require 'mechanize'
require 'gmail'
require 'yaml'
require 'parallel'

config = YAML.load(File.open(File.expand_path('../config.yml', __FILE__)))

my_list = config['my_list']
save_dir = config['save_dir']
target_url = config['latest_url']
next_page = config['next_page']
pic_type = config['pic_type']
gmail_user = config['gmail_user']
gmail_pass = config['gmail_pass']
email_target = config['email_target']

updated_counter = 0 # Counter for checking if each iteration has updates
updated_manga = []
my_list.each do |manga|
  agent = Mechanize.new
  page = agent.get(target_url)

  folder = manga.gsub(' ', '_')
  next if agent.page.links.find { |l| l.text.match(/#{manga}.*\s\d/i) }.nil?

  results = []
  results = agent.page.links_with(:text => /#{manga}.*\s\d/i)
  results.each do |release|
    page = release.click
    next if agent.page.links.find { |l| l.text.match(/#{next_page}/) }.nil?

    page.images.each { |e| @metadata = e.url.to_s if e.url.to_s.match(/#{pic_type}/i) }
    @chapter = @metadata.split('/')[-2]
    next if Dir.exists?("#{save_dir}/#{@chapter}")

    images = []
    loop do
      begin
        page.images.each { |e| @image = e.url.to_s if e.url.to_s.match(/#{pic_type}/i) }
        images << @image

        next_link = agent.page.link_with(:text => /#{next_page}/)
        page = next_link.click
      rescue Mechanize::UnsupportedSchemeError => e
        break
      end
    end

    Parallel.each(images, in_threads: 5) do |pic|
      begin
        file_name = pic.split('/')[-1]
        img = agent.get(pic)
        img.save "#{save_dir}/#{@chapter}/#{file_name}"
      rescue Mechanize::ResponseCodeError => e
        break
      end
    end
    updated_counter += 1
    updated_manga << @chapter
  end
end

if updated_counter > 0
  gmail = Gmail.new(gmail_user, gmail_pass)
  gmail.deliver do
    to email_target
    subject 'There are new manga updates'
    text_part do
      body updated_manga.join("\n")
    end
  end
  gmail.logout
end
