class FreezersController < ApplicationController
	require 'rqrcode'
	before_filter :clear_pk, only: [:create, :show]
	before_filter :clear_flash_messages
	before_filter :nuke_coldstorage_files, only: :new
	before_filter	:redirect_home,	only: [:show, :download]

  def new
		@title=freeze_page_title
	end

	def create
		@title=freeze_page_title
		howmany=params[:howmany].to_i
		$split = params[:split].to_s
		$ssss = { n: params[:ssss_n].to_i, k: params[:ssss_k].to_i }
		if valid_params?(howmany,$ssss)
			keys=KeyGenerator.new(howmany).keys
			@qm=Quartermaster.new(keys,params[:password].strip,$ssss)
			@qm.dump_files
		redirect_to new_keys_path
		else
			flash.now[:error] = build_validation_message(howmany,$ssss)
			render 'new'
		end
	end

  def show
		begin
	    flash.now[:hot] = hot_message if HOT
	  	@password= CSV.read(password_file_path('csv'))[1][0]
	  	@expose=params[:expose]
	  	# sleep 5 if (DEBUG) # this is to make it feel like the PI
	  	@n=$ssss[:n]
	  	@title=private_keys_title
	    @data=CSV.read(private_keys_file_path('csv',false))
	    @keys=build_private_keys_hash_array(@data)
	    @remote = (AJAXON && COPY && all_files_there?)
	    flash.now[:info] = instructions_flash unless @remote
		rescue => e
			Rails.logger.debug e.message
			flash[:error]= { message: missing_file_error, id: 'missing_file'}
			redirect_to home_path
		end
  end

  def download
  	begin
  		if COPY
  			copy_files
  		else
  			download_files
  		end
		rescue => e
			if e.message.scan(/Input\/output error/).blank?
				logger.error(e.message)
				flash[:error]= { message: missing_file_error, id: 'missing_file' }
				redirect_to home_path
			else
				flash[:danger] = { message: no_usb_message, title: 'Insert a USB drive', id: 'no_usb' }
				redirect_to new_keys_path
			end
		end
  end


  private

  	def copy_files
			unless usb_attached?
				cookies[:copy] = 'no_usb'
				flash[:danger] = {message: no_usb_message,title: 'Insert a USB drive', id:'no_usb'}
				redirect_to new_keys_path
			else
				set_copy_cookie
				case params[:download]
				when /addresses/
					origin=public_addresses_file_path('csv',false)
					target=public_directory_path(true)+addresses_file_name+'.csv'
					FileUtils.mkdir_p File.dirname(target)
			  	FileUtils.cp(origin,target)
			  	flash[:success] = {message: "Bitcoin addresses"+success_copy_suffix,title: success_copy_title(cold_storage_directory_name),id: 'addr_download_success'}
			  when 'unencrypted_private_keys'
			  	origin = private_keys_file_path('csv',false)
			  	target = unencrypted_directory_path(true)+private_keys_file_name+'.csv'
			  	FileUtils.mkdir_p File.dirname(target)
			  	FileUtils.cp(origin,target)
			  	flash[:success] = {message: "NON-ENCRYPTED private keys"+success_copy_suffix,title: success_copy_title(cold_storage_directory_name),id: 'plain_download_success'}
			  when 'encrypted_private_keys'
			  	origin = private_keys_file_path('csv',true)
			  	target = encrypted_directory_path(true)+private_keys_file_name+'.csv'+encrypted_file_suffix
			  	FileUtils.mkdir_p File.dirname(target)
			  	FileUtils.cp(origin,target)
			  	flash[:success] = {message: "Encrypted private keys"+success_copy_suffix,title: success_copy_title(cold_storage_directory_name),id: 'encrypted_download_success'}
				when 'password'
					origin=password_file_path('csv',false)
					target=encrypted_directory_path(true)+password_file_name+'.csv'
					FileUtils.mkdir_p File.dirname(target)
			  	FileUtils.cp(origin,target)
			  	flash[:success] = {message: "Password"+success_copy_suffix,title: success_copy_title(cold_storage_directory_name),id: 'pass_download_success'}
			  when 'password_share'
			  	origin = password_shares_path(params[:share].to_i)
			  	target = encrypted_directory_path(true) +password_share_file_name + '_' + params[:share].to_i.to_s + '.csv'
			  	FileUtils.mkdir_p File.dirname(target)
			  	FileUtils.cp(origin,target)
			  	flash[:success] = {message: "#{params[:share].to_i.ordinalize} password share" +success_copy_suffix,title: success_copy_title(cold_storage_directory_name),id: "share_#{params[:share].to_s}_download_success"}
			  else
			  	redirect_to home_path
			  end
			  redirect_to new_keys_path
			end
  	end

  	def download_files
 	  	case params[:download]
	  	when /addresses/
		  	send_file public_addresses_file_path('csv',false), filename: addresses_file_name+".csv"
		  when 'unencrypted_private_keys'
		  	send_file private_keys_file_path('csv',false), filename: private_keys_file_name+".csv"
		  when 'encrypted_private_keys'
		  	send_file private_keys_file_path('csv',true), filename: private_keys_file_name+".csv"+encrypted_file_suffix
	  	when 'password'
		  	send_file password_file_path('csv',false), filename: password_file_name+".csv"
		  when 'password_share'
		  	send_file password_shares_path(params[:share].to_i), filename: password_share_file_name+'_'+params[:share]+'.csv'
		  else
		  	redirect_to home_path
		  end
  	end

	  def freezers_params
	    params.require(:keys).permit(:howmany, :password)
	  end

	  def clear_flash_messages
	  	flash[:error].clear if flash[:error]
	  end

	  def redirect_home
	  	unless all_files_there?
				logger.warn('Not all coldstorage files were found.')
				cookies[:copy] = 'missing_files'
		  	flash[:error]= {message: missing_file_error,id: 'missing_file'}
		  	redirect_to home_path
	  	end
	  end
	  def build_validation_message(howmany,ssss_hash)
	  	message=""
	  	message << addresses_range_notice + ". " unless (1..KEYS_LIMIT).include?(howmany)
	  	message << at_least_two_shares_flash + ". " unless (2..SHARES_LIMIT).include?(ssss_hash[:n]) && (2..SHARES_LIMIT).include?(ssss_hash[:k])
	  	message << k_not_smaller_than_n_flash + ". " unless ssss_hash[:k]<ssss_hash[:n]
	  	return message
	  end
	  def valid_params?(howmany,ssss_hash)
	  	(1..KEYS_LIMIT).include?(howmany) && (2..SHARES_LIMIT).include?(ssss_hash[:n]) && (2..SHARES_LIMIT).include?(ssss_hash[:k]) && ssss_hash[:k]<ssss_hash[:n]
	  end
	  def instructions_flash
			if COPY
				{message: "#{'Insert a USB stick and' unless usb?} Download your cold storage files #{'to the USB stick' if usb?}", hide: false,id: 'instruction',close: false}
			else
				{message: "Use the Download buttons to download your cold storage files", hide: false,id: 'instruction_fc',close: true}
			end
	  end
end


# `mount`.split("\n").grep(/media\/usb/)[0].split(/media\/usb/)[1].split(/type/)[0].to_i
# /(\/media\/usb)(\d+)(\s+type)/.match(`mount`)[2]
# regy=/(\/media\/usb)(\d+)(\s+type)/
# `mount`.scan(regy).map{|x| p x[1].to_i}
