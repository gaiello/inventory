class Database
    attr_accessor :db
    
    #Making db connection
    def initialize
  	   @db = db
       @db = Sequel.sqlite('lib/inventory.db')
    end
    
    #Initializing table if they dont exist.
  	def create
    		unless @db.table_exists? :items
  			@db.create_table(:items) do
  	      		primary_key :id
  	      		String :artist
  	      		String :title
  	      		Integer :release_year
  	      		String :format
              String :uid
  	    	end
  	  	end
    end
    
    #Items table
    def get_items(arg0 = nil)
        create
        case arg0
        when 'artist'
    		    return @db[:items].order(:artist)
        when 'title'
            return @db[:items].order(:title)
        when 'release_year'
            return @db[:items].order(Sequel.desc(:release_year))
        when 'format'
            return @db[:items].order(Sequel.desc(:format))
        else
            return @db[:items].order(:artist)
        end
        puts "GETTING ITEMS"
    end

    #Counts of specific formats by artist
    def get_count(items, artist, format)
        begin
            items.filter("format = '#{format.downcase}' and artist LIKE '%#{artist}%'").count.to_i
        rescue
            "0"
        end
    end

    #The first UID for display
    def get_uid(items, artist, format)
        begin
            items.filter("format = '#{format}' and artist LIKE '%#{artist}%'").first[:uid]
        rescue
            ""
        end
    end

    #Display the inventory
    def display(items, arg0, arg1)
        case arg0
        when 'artist', 'title', 'release_year', 'format'
            items.where("#{arg0.downcase} LIKE '%#{arg1}%'").group_by(:artist).each do |item|
                display_item(item, items, arg0, arg1)
            end
        when 'all'
            items.group_by(:artist).each do |item|
                display_item(item, items, 'artist', item[:artist])
            end
        end
    end

    #Each inventory item formatted
    def display_item(item, items, arg0, arg1)
        puts "Artist: #{item[:artist]}"
        puts "Album: #{item[:title]}"
        puts "Released: #{item[:release_year]}"
        puts "CD(#{get_count(items, "#{item[:artist]}", 'cd')}): #{get_uid(items, "#{item[:artist]}", 'cd')}" if get_count(items, item[:artist], 'cd') != 0
        puts "Tape(#{get_count(items, "#{item[:artist]}", 'tape')}): #{get_uid(items, "#{item[:artist]}", 'tape')}" if get_count(items, item[:artist], 'tape') != 0
        puts "Vinyl(#{get_count(items, "#{item[:artist]}", 'vinyl')}): #{get_uid(items, "#{item[:artist]}", 'vinyl')}" if get_count(items, item[:artist], 'vinyl') != 0
        puts ""
    end
end