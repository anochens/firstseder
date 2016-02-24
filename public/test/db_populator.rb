require 'net/ftp'
require_relative 'config.cnf'

def process(file_name)
	sname = "s437696020.onlinehome.us"
	file_arr = file_name.split('/')

	#puts file_arr.inspect

	category = file_arr[1].strip
	fname = file_arr[2]

   chunks = fname.split(',')
	n = chunks.length

	title = ''
	date = '0-0-0'
	magid = 'no magid'
	subcat = 'no subcat'

	#last chunk is always the date
	if(n>1)
		fulldate = chunks[-1]
		date = fulldate.strip.split('.')[0].strip
	end              

	if(n>2)  
		nmagid = chunks[-2].strip
		
		if(!nmagid.start_with?('Amud')) 
			magid = nmagid 
		end
	end

   if(category.start_with?('Maseches'))
		subcat = category.strip 
		category = 'Gemara'
	elsif(chunks.length > 1 && chunks[0].strip != category.strip) 
		subcat = chunks[0].strip
	end

	subcat.strip!
	category.strip!
	subcat.strip!
	title.strip!

	location = file_name

	if(subcat == title)
		title = 'no title'
	end

	title=chunks.join(',')

   title.sub!(/(, )?#{date}/,'')
   title.sub!(/(, )?#{magid}/,'')
   title.sub!(/(, )?#{category}/,'')
   title.sub!(/(, )?#{subcat}/,'')
   title.sub!(/^ ?, ?/,'')
   title.sub!(/^ ?- ?/,'')
	title.sub!('.WMA','')
	title.sub!('.MP3','')

	id = 0;
	magid_id = 0
	cat_id = 0
	subcat_id = 0
	loc_link = sname+location
	desc = ''


	magid_id = magid
	cat_id = category
	subcat_id  = subcat



	out = [id, magid_id, cat_id, subcat_id, title, desc, loc_link, date,0,0]
	out = out.map{|m| "\"#{m}\""}

	out
end	

$shiurs = []

def scan(ftp, dir)
	ftp.chdir(dir)
	puts ftp.pwd + "/."
	entries = ftp.list('*')
	entries.each do |entry|
		if entry.split(/\s+/)[0][0,1] == "d" then


#useing regex doesnt skiop continuous spaces, which is what we want. but need to change the 8 below to the real start position of the title
			fs =  entry.split(/ /)
			new_entry = fs[8,fs.length-1].join(' ')

			puts fs.inspect
			
			scan(ftp, new_entry)
		else
			fs =  entry.split
			new_entry = fs[8,fs.length-1].join(' ')
			full_name = ftp.pwd + "/" + new_entry
			p = process(full_name)
			puts p.join(',');
			$shiurs.push(p)
		end
	end
	ftp.chdir('..')
end

ftp = Net::FTP.new($sname)
ftp.passive = true
ftp.login( $uname, $pw )
scan(ftp, '/')
ftp.close


puts shiurs.join("\n")
