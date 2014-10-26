# encoding: utf-8
require 'rubygems'
require 'mechanize'
require 'yaml'

config = YAML.load(File.open(File.expand_path('../config.yml', __FILE__)))

manga_dir = config['manga_dir']
main_url = config['main_url']

manga = ARGV[0]
agent = Mechanize.new
agent.get(manga_dir)

search = agent.page.links_with(:text => /#{manga}.*\s\d/i)
puts 'No series found.' if search.empty?

unless search.empty?
  urls = []
  results = []

  search.each { |e| urls << e.uri.to_s }
  urls.each do |e|
    arr = e.split('/')
    arr.pop
    convert = arr.join('/')
    results << convert
  end

  results.each { |e| puts "#{main_url}#{e}" }
end
