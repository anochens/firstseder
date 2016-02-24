require '../../config/environment'
require 'set'
require 'date'
require 'net/ftp'
require_relative 'config.cnf'

#not needed anymore since created on the fly
#$maggids = Set.new
#$categories = Set.new
#$subcats = Set.new

$n = 0


def process(file_name)
	sname = "s437696020.onlinehome.us"
	file_arr = file_name.split('/')

	#puts file_arr.inspect

	category = file_arr[1].strip
	fname = file_arr[2]

   chunks = fname.split(',')
	n = chunks.length

	title = ''
	date = '1-1-1900'
	magid = 'no magid'
	nmagid = 'no magid'
	subcat = 'no subcat'

	#last chunk is always the date
	if(n>1)
		fulldate = chunks[-1]
		date = fulldate.strip.split('.')[0].strip # get rid of extension

#if there are problems with stuff before the date, get rid of them
		datesplit = date.split(' ')
		date = date.split(' ')[-1] if datesplit.length>1
	end              

	if(n>2)  
		nmagid = chunks[-2].strip
	end
		
	magid = nmagid #store even bad ones now, will remove them later
	mymagid = Magid.where(:name => magid).first_or_create()
	magid_id = mymagid.id

#		puts mymagid.inspect
#		puts magid_id.inspect
#		abort

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

#-------------------
	mycategory = Category.where(:name => category).first_or_create()
	category_id = mycategory.id

#	puts mycategory.inspect
#	puts category_id.inspect
#	abort() 
#-------------------
	mysubcat = Subcat.where(:name => subcat).first_or_create()
	mysubcat.category_id = category_id
	subcat_id = mysubcat.id

	puts mysubcat.inspect
	puts subcat_id.inspect
	abort() 
#-------------------
         
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
	loc_link = sname+location
	desc = ''

	myshiur = Shiur.where(:name => title).first_or_create()
	myshiur.magid_id = magid_id
	myshiur.category_id = category_id
	myshiur.subcat_id = subcat_id
	myshiur.location_link = loc_link
	myshiur.description = '' # gets set to fs late'' # gets set to fs laterr
	begin
		shiur_date = Date.strptime(date,'%m-%d-%Y')
		myshiur.shiur_date = shiur_date

	rescue
		#abort('date is: |'+date+'|')
		myshiur.shiur_date = date
	end

#just for testing
	puts myshiur.inspect
	n+=1

	abort if n>50
# end just for testing

	myshiur

    
   #dont need to output this since using activerecord to create
#using the objects!
#	out = [id, magid_id, cat_id, subcat_id, title, desc, loc_link, date,0,0]
#	out = out.map{|m| "\"#{m}\""}
#	out
end	

$shiurs = []

def scan(ftp, dir)
	ftp.chdir(dir)
	puts ftp.pwd + "/."
	entries = ftp.list('*')
	entries.each do |entry|
		if entry.split(/\s+/)[0][0,1] == "d" then

			fs =  entry.split(' ')
			new_entry = fs[8,fs.length-8].join(' ')
			
			scan(ftp, new_entry)
		else
			fs =  entry.split
			new_entry = fs[8,fs.length-1].join(' ')
			full_name = ftp.pwd + "/" + new_entry
			p = process(full_name)
			p.description = 'xxxxx'#new_entry
		end
	end
	ftp.chdir('..')
end

ftp = Net::FTP.new($sname)
ftp.passive = true
ftp.login( $uname, $pw )
scan(ftp, '/')
ftp.close


#bad_magids = ['Amud, Aumd','Pasuk','Perek','Sif','Siman','Mishnah']
#is_bad_magid = false;
#bad_magids.each{|m|
#	$maggids.each{|m2|
#		if(!m2.downcase.start_with?(m.downcase)) 
#			m2 = 'bad magid'
#		end                 
#	}
#}      

                  
