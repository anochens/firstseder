class Subcategory < ActiveRecord::Base
	has_one :category
	
end
