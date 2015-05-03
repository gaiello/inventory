require 'rubygems'
require "bundler/setup"
require 'optparse'
require 'sequel'
require './lib/database'
require 'securerandom'
require 'csv'

options = {}
accepted_formats = { ".csv" => ",", ".pipe" => "|" }
record_count = 0

opt_help = OptionParser.new do |opt|
	opt.banner = "This application loads inventory file."
	opt.separator  ""
	opt.separator  "The two formats that are allowed are pipe-delimited and comma-separated."
	opt.separator  "Example Usage: ruby load_inventory.rb cd_sellers.csv"
end

opt_help.parse!

#Initializing the database and getting items and item quantities
db = Database.new
items = db.get_items

case ARGV[0]
when "-h"
	puts opt_help
else
	if ARGV[0] != nil
		puts "Importing file: #{ARGV[0]}............."
		path = "#{ARGV[0]}"
		if File.exist?(path)
			ext = File.extname(path)
			if accepted_formats.has_key? "#{ext}"
				f = File.open(path, "r")
				f.each_line do |line|
					line.split(/\r/).each do |row|
						case accepted_formats[ext]
						when '|'
							item = row.split(accepted_formats[ext])
							for i in 1..item[0].to_i do
    							items.insert(:artist => item[3].strip.split.map(&:capitalize).join(' '), :title => item[4].strip.split.map(&:capitalize).join(' '), :release_year => item[2].strip, :format => item[1].strip.downcase, :uid => SecureRandom.uuid)
    							record_count += 1
							end
		    			when ','
		    				item = CSV.parse(row.gsub('\"', '""')).first
		    				items.insert(:artist => item[0].strip.split.map(&:capitalize).join(' '), :title => item[1].strip.split.map(&:capitalize).join(' '), :release_year => item[3].strip, :format => item[2].strip.downcase, :uid => SecureRandom.uuid)
		    				record_count += 1
		    			end
		    		end
		  		end
	  		else
	  			puts "File must be a .pipe or .csv"
	  		end
	  	end
      	puts "FILE IMPORTED"
      	puts "Total Records Imported #{record_count}"
	else
  		puts "Please provide an import file.  If you need help please execute: ruby load_inventory.rb -h"
	end
end