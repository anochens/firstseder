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




def sortable(column, title = nil)
	title ||= column.titleize
	css_class = column == sort_column ? "current #{sort_direction}" : nil
	direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
	link_to title, {:sort => column, :direction => direction}, {:class => css_class}
	end
end
