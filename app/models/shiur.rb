class Shiur < ActiveRecord::Base
	attr_accessor :new_magid_name

	belongs_to :magid
	belongs_to :category
	belongs_to :subcat
end
