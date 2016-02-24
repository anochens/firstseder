module ApplicationHelper
	def get_name(v, defname = '')
		if !v.nil?
			v.name
		else
			defname
		end
	end
end
