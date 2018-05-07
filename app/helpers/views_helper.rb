module ViewsHelper

	def app_title
		'CoinCooler'
	end

	def full_title(string)
		if string.to_s.length > 0
			app_title + " - " + string.to_s
		else
			app_title
		end
	end

	def get_id(file)
		# Digest::MD5.hexdigest(string)[0..10]
		File.basename(file, ".*")[1..-1]
	end

	def home_title
		'Home'
	end

	def heatup_header
		'Recovered Addresses'
	end
	def howmany_sentence
		'Number of addresses to generate: '
	end
	def failed_decryption_message
		'Decryption have failed. Try again..'
	end
	def generate_button
		'Generate Cold Storage Files'
	end
	def generate_button_action
		'Generating Cold Storage Files'
	end
	def generate_button_title
		"Generate a list of Bitcoin Addresses and the Private Keys that control them."
	end
	def generate_button_title_advanced
		generate_button_title+"\nThe list is automatically encrypted and the password used for encryption divided into shares."
	end
	def recover_addresses_button
		'Recover Addresses'
	end
	def advanced_options_button
		'Advanced Options'
	end
	def howmany_placeholder
		'How many?'
	end
	def addresses_header
		'Address'
	end
	def keys_header
		'Private Key'
	end

	def recover_passwd_placeholder
		'Enter password'
		# 'Your cold storage password'
	end

	def shares_placeholder
		'Or, enter password shares (encrypted files only)'
		# 'Your cold storage password'
	end

	def inspect_page_title
		'Upload and Inspect the content of existing cold storage files'
	end

	def inspect_page_header
		inspect_page_title
	end

	def uploads_title
		inspect_page_title
	end

	def inspect_button
		'Inspect'
	end
	def big_inspect_button
		'Inspect Existing Files'
	end
	def upload_button
		'Upload a File for Inspection'
	end
	def upload_button_shares
		'Upload Password Shares'
	end
	def upload_button_password
		'Upload Password File'
	end
	def recover_button
		'Inspect cold storage file'
	end
	def recover_button_action
		'preparing file for inspection'
	end
	def recover_button_title
		"Inpsect the content of the cold storage file you just uploaded"
	end
	def inspect_button_title
		"Upload Cold Storage files for inspection"
	end
	def big_inspect_button_title
		'Upload existing cold storage files to inspect the list of Addresses and Private Keys'
	end
	def freeze_page_title
		'Generate Bitcoin Addresses for Cold Storage'
	end

	def freeze_page_header
		'Generate Cold Storage files'
	end

	def freeze_button
		'Generate'
	end
	def big_freeze_button
		'Generate New Files'
	end
	def big_freeze_button_title
		'Generate cold storage files listing new Bitcoin Addresses and Private Keys'
	end
	def freeze_button_title
		freeze_page_title
	end

	def addresses_title
		'Bitcoin Addresses'
	end

	def private_keys_title
		'Private Keys'
	end

	def enter_password_placeholder
		'Override our strong password with your own? (optional)'
		# 'Your Password (optional)'
	end

	def catch_phrase_big
		'Bitcoin Cold Storage'
	end
	def catch_phrase_small
		'made easy'
	end
	def elevator_pitch
		'Generate and Inspect cold storage files on your Offline RaspberryPi'
	end
	def addresses_range_notice
		'The number of addresses must be an interger between 1 and ' + KEYS_LIMIT.to_s
	end

	def entropy_explanation(length, alphabet, entropy)
		size=[(entropy -1).round.to_i,0].max.to_s
		'A brute force search for a word of length '+length.to_s + ' in the alphabet [' + alphabet.to_s + '] requires ~ 2^' + size + ' trials, on average.'
	end

	def download_non_encrypted_link
		' NON-ENCRYPTED Keys '
	end
	def download_row_button
		'Download'
	end
	def download_row_title
		'Download a file containing just this Private Key and the associated Addresses'
	end
	def download_encrypted_link
		' Encrypted Keys '
	end
	def download_password_link
		' Your Password '
	end
	def save_non_encrypted_title
		'Save a NON-ENCRYPTED copy'
	end
	def save_encrypted_title
		'Save an encrypted copy'
	end
	def download_keys_button
		'Download Private Keys'
	end
	def download_addresses_button
		'Download Addresses'
	end
	def download_upload_button
		'Download File'
	end
	def home_link_title
		'CoinCooler Home page'
	end
	def missing_file_error
		'An error occured, please try again'
	end
	def upload_format_error
		incorrect_format_flash
	end
	def incorrect_format_flash
		'The uploaded file is not in the correct format'
	end
	def wrong_password_flash
		'Wrong password, try again'
	end
	def no_file_loaded_flash
		'No file was loaded'
	end
	def qr_button
		'Show QR'
	end
	def download_upload_title
		if COPY
			'Save this file to a USB drive'
		else
			'Download this file'
		end
	end
	def qr_button_title
		if PI
			"Show QR code (slow, takes about 25 seconds)"
		else
			"Show QR code"
		end
	end
	def show_key_button
		'Show the Private Key'
	end
	def show_key_title
		'Show the private key. Make sure you are in a private setting where no one else can see your screen'
	end
	def hide_key_button
		'Hide the Private Key'
	end
	def ssss_n_placeholder
		'total'
	end
	def ssss_k_placeholder
		'minimal'
	end
	def ssss_n_title
		'Total number of shares'
	end
	def ssss_k_title
		'Minimal number of shares needed for password retrieval'
	end
	def upload_shares_button
		"OR, Upload Share Files"
	end
	def at_least_two_shares_flash
		'Number of shares must be an interger between 2 and '+ SHARES_LIMIT.to_s
	end
	def k_not_smaller_than_n_flash
		'The number of shares required for password reconstruction must be smaller than the total number of shares'
	end
	def hot_message
		'Do NOT use these addresses for cold storage! You are online!'
	end

	def success_copy_suffix
		" file was copied to your USB drive"
	end
	def row_success_copy_suffix
		success_copy_suffix[5..-1]
	end
	def success_copy_title(string='')
		"The file was copied to the USB flash drive in a directory named: #{string}"
	end
	def download_addresses_title
		if COPY
			'Save a file containing the list of Addresses to a USB drive'
		else
			'Download a file containing the list of Addresses'
		end
	end
	def download_unencrypted_title
		if COPY
			"Save the list of PRIVATE KEYS and Addresses to a USB drive, NON-ENCRYPTED"
		else
			"Download an UNENCRYPTED list of PRIVATE KEYS and Addresses"
		end
	end
	def download_keys_title
		if COPY
			"Save files containing the list of PRIVATE KEYS to a USB drive"
		else
			"Download files containing the list of PRIVATE KEYS"
		end
	end
	def pbkdf_alert_message
		'Please wait....'
	end
	def pbkdf_alert_prefix
		'To protect against brute force attacks your password is processed '
	end
	def pbkdf_alert_suffix
		' times through a Password Based Key Derivation Function (PBKDF)'
	end
	def pbkdf_alert_title
		pbkdf_alert_prefix+PBKDF2_ITERATIONS.to_s+pbkdf_alert_suffix
	end
  def wrong_ks_init_message
    'Kingslayer should be initialized EITHER with a password and (optionally) an iteration number, OR with an init key'
  end
  def wrong_init_key_format_message
    'Kingslayer init_key must be a 256 bit string in hex format (64 characters long), e.g: d7a99f252799a52c54aab86bf35741833faa4dbb607903332aad9bc53574512c'
  end
  def no_usb_message
  	"No USB storage detected. Please insert a USB drive and try again"
  end
  def download_encrypted_title
  	" #{if COPY then "Save" else "Download" end} an encrypted file containing this list of PRIVATE KEYS and Addresses #{" to a USB drive" if COPY}"
  end
  def download_password_title
  	" #{if COPY then "Save" else "Download" end} a file containing the password #{" to a USB drive" if COPY}"
  end
  def download_unencrypted_title
  	" #{if COPY then "Save" else "Download" end} a non-encrypted file containing this list of PRIVATE KEYS and Addresses #{" to a USB drive" if COPY}"
  end

end
