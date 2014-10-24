# encoding: utf-8
require 'rubygems'
require 'mechanize'
require 'yaml'
require 'parallel'

config = YAML.load(File.open(File.expand_path('../config.yml', __FILE__)))

save_dir = config['save_dir']
pic_type = config['pic_type']
page_not_found = '404_img.jpg'

search_params = ARGV
target_url = search_params[0] # http://www.mangahere.co/manga/manga_name/

folder = search_params[0].split('/')[-1]
manga = search_params[0].split('/')[-1].split('_')[0]

agent = Mechanize.new
page = agent.get(target_url)

results = []
results = agent.page.links_with(:text => /#{manga}.*\s\d/i)
results.reverse!
fail 'No results' if results.empty?
pp "#{results.size} chapters found, downloading..."

chapter_counter = 0
results.each do |release|
  chapter_counter += 1
  page = release.click
  url = page.uri.to_s
  next if Dir.exists?("#{save_dir}/#{folder}/ch#{chapter_counter}")

  arr = []
  100.times do |e|
    arr << "#{url}#{e += 1}.html"
  end

  images = []
  arr.each do |crafted_url|
    begin
      @image = page.images[0].to_s if page.images[0].to_s.match(/#{pic_type}/)
      break if @image.nil?
      break if @image.match(/#{page_not_found}/)

      images << @image
      page = agent.get(crafted_url)
    rescue Mechanize::UnsupportedSchemeError => e
      break
    end
  end

  images.shift
  Parallel.each(images, in_threads: 3) do |pic|
    begin
      file_name = pic.split('/')[-1].match(/.*#{pic_type}/)
      img = agent.get(pic)
      img.save "#{save_dir}/#{folder}/ch#{chapter_counter}/#{file_name}"
    rescue Mechanize::ResponseCodeError => e
      break
    end
  end
  pp "Chapter #{chapter_counter}/#{results.size} is downloaded."
end
