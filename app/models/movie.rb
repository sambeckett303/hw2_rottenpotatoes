class Movie < ActiveRecord::Base
	attr_accessible :title, :ratings
	def self.ratings 
		['G','PG','PG-13','R']
    end
end
