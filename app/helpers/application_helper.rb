module ApplicationHelper



#this is used to get around the problems of nils causing errors 
#when a field isn't set right
	def get_name(v, defname = '')
		if !v.nil?
			v.name
		else
			defname
		end
	end
end
