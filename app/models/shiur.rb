class Shiur < ActiveRecord::Base
	attr_accessor :new_magid_name, :new_category_name, :new_subcat_name

	belongs_to :magid
	belongs_to :category
	belongs_to :subcategory, :foreign_key =>'subcat_id'
end
