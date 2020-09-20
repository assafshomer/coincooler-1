module FilesHelper
	require 'csv'
	require 'bitcoin'
	include PathHelper

	def save_file(path, data)
		path = File.expand_path path
		dirpath = File.dirname(path)
  	FileUtils.mkdir_p dirpath
  	FileUtils.chmod 'a+w', dirpath
		File.open(path,'w+') {|file| file.write data }
	end

	def delete_file(path)
		File.delete(path) if File.exist?(path)
	end

	def file_there?(path)
		File.exist?(path)
	end

	def read_address_csv(path)
		CSV.read(path,headers: true,col_sep: "\t").map do |row|
			[row[0],row[1]]
		end
	end

	def save_csv(path,header_array,data_nested_array)
		path = File.expand_path path
		dirpath = File.dirname(path)
  	FileUtils.mkdir_p dirpath
  	FileUtils.chmod 'a+w', dirpath
		CSV.open(path,"wb",col_sep: ",") do |csv|
			csv << header_array
			data_nested_array.each do |row|
				csv << row
			end
		end
	end

	def save_enum_csv(path,header_array,data_nested_array, start_position=1)
		path = File.expand_path path
		dirpath = File.dirname(path)
  	FileUtils.mkdir_p dirpath
  	FileUtils.chmod 'a+w', dirpath
		CSV.open(path,"wb",col_sep: ",") do |csv|
			csv << header_array.unshift('#')
			data_nested_array.each do |row|
				csv << row.unshift(data_nested_array.index(row)+start_position)
			end
		end
	end

	def addresses_csv_format?(csv_data)
		return false unless csv_data.kind_of?(Array)
		return false if csv_data[0][0]!="#"
		return false if csv_data[0][1]!="Bitcoin Address"
		return false if csv_data[0][2]!=nil
		return false if csv_data[1][0]!="1"
		return false if csv_data[1][2]!=nil
		return false unless Bitcoin::valid_address?(csv_data[1][1])
		true
	end

	def private_keys_csv_format?(csv_data)
		return false unless csv_data.kind_of?(Array)
		return false if csv_data[0][0]!="#"
		return false if csv_data[0][1]!="Bitcoin Address"
		return false if csv_data[0][2]!="Private Key"
		return false if csv_data[0][3]!=nil
		return false if csv_data[1][0]!="1"
		return false if csv_data[1][3]!=nil
		return false unless Bitcoin::valid_address?(csv_data[1][1])
		# bug in Bitcoin::Key
		# > key = Bitcoin::Key.generate
		# > pk = key.to_base58
		# > Bitcoin::Key.from_base58(pk)
		# CRASH
		# return false unless Bitcoin::Key.from_base58(csv_data[1][2]).addr == csv_data[1][1]
		true
	end

	def share_csv_format?(csv_data)
		return false unless csv_data.kind_of?(Array)
		return false unless csv_data[0].kind_of?(Array)
		return false unless csv_data[1].kind_of?(Array)
		return false if csv_data[0][0]!="Password Share"
		return false if csv_data[1][0].blank?
		true
	end

	def password_csv_format?(csv_data)
		return false unless csv_data.kind_of?(Array)
		return false unless csv_data[0].kind_of?(Array)
		return false unless csv_data[1].kind_of?(Array)
		return false if csv_data[0][0]!="Password"
		return false if csv_data[1][0].blank?
		true
	end

  def save_csv_for_row(number,path)
    header=['Bitcoin Address','Private Key']
    data=[[]]
    data[0] << $keys[number-1][:addr]
    data[0] << $keys[number-1][:private_wif]
    save_enum_csv(path,header,data, number)
  end

	def get_stale_uploads_array
		stale_array=Dir.glob(jquery_uploads_dir+"/**/").map{|p| p.gsub!('//','/')}
		stale_array.delete(jquery_uploads_dir)
		stale_array.delete_if {|p| p=~/\/#{ID}\//}
	end

	def nuke_stale_uploads(path_array=get_stale_uploads_array)
		path_array.each {|p| FileUtils.rm_rf(p)}
	end

	def nuke_all_uploads
		secure_delete jquery_uploads_dir
	end

	def clear_stale_uploads
    nuke_stale_uploads
    Upload.all.each {|u| u.destroy unless file_there?(u.upload.path)} if Upload.count.positive?
  end

	def nuke_all_uploads_on_rp
  	nuke_all_uploads if PI
  end

	def nuke_coldstorage_files
		clear_coldstorage_dirs_on_usb
		clear_coldstorage_files_locally
	end

	def clear_coldstorage_dirs_on_usb
		return if PROD
		secure_delete "#{usb_path}#{cold_storage_directory_prefix}"
	end

	def clear_coldstorage_files_locally
		secure_delete coldstorage_directory
	end

	def secure_delete(dir_path)
		TEST ? FileUtils.rm_rf(Dir["#{dir_path}*"]) : system("srm -r #{dir_path}*")
	end

	def files_exist?
		File.exists?(public_addresses_file_path('csv')) ||
		File.exists?(private_keys_file_path('csv',false)) ||
		File.exists?(private_keys_file_path('csv',true)) ||
		File.exists?(password_file_path('csv')) ||
		$split == "yes" ? shares_there? : false
	end

	def all_files_there?
		File.exists?(public_addresses_file_path('csv')) &&
		File.exists?(private_keys_file_path('csv',false)) &&
		File.exists?(private_keys_file_path('csv',true)) &&
		File.exists?(password_file_path('csv')) &&
		$split == "yes" ? shares_there? : true
	end

	def shares_there?
		!Dir.glob(password_shares_path(1)[0..-(6+$tag.to_s.length)]+'*'+$tag.to_s+'.csv').empty?
	end

# FileUtils.cp_r(coldstorage_directory,'/home/assaf/Desktop')
# FileUtils.mkdir_p usb_path+'foo/bar'
# FileUtils.rm_rf(Dir.glob('/media/usb3/*'))
end
