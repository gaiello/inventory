require 'rubygems'
require "bundler/setup"
require 'optparse'
require 'sequel'
require './lib/database'

options = {}

opt_help = OptionParser.new do |opt|
    opt.banner = "This application searches inventory."
    opt.separator  ""
    opt.separator  "Example Usage: ruby search_inventory.rb artist Nas"
    opt.separator  ""
    opt.separator  "Searches can be done by:"
    opt.separator  "artist, format, release_year and title"
    opt.separator  ""
    opt.separator  "You can also search by all: ruby search_inventory.rb all"
end

opt_help.parse!

#Initializing the database and getting items and item quantities
db = Database.new
items = db.get_items(ARGV[0])

case ARGV[0]
when "-h"
    puts opt_help
else
    begin
        db.display(items, ARGV[0], ARGV[1])
        puts "FINISHED QUERY"
    rescue
       puts "There is something wrong with your search parameters.  Example Usage: ruby search_inventory.rb artist Nas"
    end
end