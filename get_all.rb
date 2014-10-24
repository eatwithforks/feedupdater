# encoding: utf-8
require 'rubygems'
require 'mechanize'
require 'yaml'
require 'parallel'

config = YAML.load(File.open(File.expand_path('../config.yml', __FILE__)))

save_dir = config['save_dir']
next_page = config['next_page']
pic_type = config['pic_type']

target_url = ARGV[0]
folder = target_url.split('/')[-1]
manga = target_url.split('/')[-1].split('-')[0]

agent = Mechanize.new
page = agent.get(target_url)

results = []
results = agent.page.links_with(:text => /#{manga}.*\s\d/i)
results.reverse!
pp "#{results.size} chapters found, downloading..."

results.each do |release|
  page = release.click
  next if agent.page.links.find { |l| l.text.match(/#{next_page}/) }.nil?

  page.images.each { |e| @metadata = e.url.to_s if e.url.to_s.match(/#{pic_type}/) }
  @chapter = @metadata.split('/')[-2]
  next if Dir.exists?("#{save_dir}/#{folder}/#{@chapter}")

  images = []
  loop do
    begin
      page.images.each { |e| @image = e.url.to_s if e.url.to_s.match(/#{pic_type}/) }
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
      img.save "#{save_dir}/#{folder}/#{@chapter}/#{file_name}"
    rescue Mechanize::ResponseCodeError => e
      break
    end
  end
  pp "#{@chapter} is downloaded."
end
