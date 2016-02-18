class Category < ActiveRecord::Base
	has_many :subcats
	has_many :shiurs
end
