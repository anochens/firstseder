class Magid < ActiveRecord::Base
	has_many :shiurs
	validates_presence_of :name
end
