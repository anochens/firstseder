class Subcat < ActiveRecord::Base
	belongs_to :category
   has_many :shiurs, through: :categories

	validates_presence_of :category
	validates_presence_of :name
end
