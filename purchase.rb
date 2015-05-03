require 'rubygems'
require "bundler/setup"
require 'optparse'
require 'sequel'
require './lib/database'

options = {}

opt_help = OptionParser.new do |opt|
    opt.banner = "This application removes an item from inventory."
    opt.separator  ""
    opt.separator  "Example Usage: ruby purchase.rb <uid>"
    opt.separator  ""
end

opt_help.parse!

#Initializing the database and getting items
db = Database.new
items = db.get_items

case ARGV[0]
when "-h"
    puts opt_help
else
    begin
        items.filter(:uid => ARGV[0]).delete
        puts "Removed #{ARGV[0]} from the inventory."
    rescue
       puts "There is something wrong with your purchase parameter.  Example Usage: ruby purchase.rb <uid>"
    end
end