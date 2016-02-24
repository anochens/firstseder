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


	bad_magids = ['Amud, Aumd','Pasuk','Perek','Sif','Siman','Mishnah']
	magid = nmagid  unless bad_magids.include? nmagid 

   magid = 'none' if magid.nil? || !magid


	mymagid = Magid.where(:name => magid).first_or_create!
#		puts mymagid.inspect
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
	mycategory = Category.where(:name => category).first_or_create!
#	puts mycategory.inspect
#	abort() 
#-------------------
	mysubcat = Subcategory.where(:name => subcat).first_or_create!
	mysubcat.category_id = mycategory.id

#	puts mysubcat.inspect
#	abort() 
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

	myshiur = Shiur.where(:name => title).first_or_create!
	myshiur.magid = mymagid
	myshiur.category = mycategory
	myshiur.subcategory = mysubcat
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
	myshiur.save!
	myshiur.reload
	puts myshiur.inspect
	n+=1

	abort if n>50
# end just for testing

	myshiur
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
			p = process(full_name) if new_entry != '_RawFiles'
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

                  
