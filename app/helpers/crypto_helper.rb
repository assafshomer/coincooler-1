module CryptoHelper

	def encrypt(password, file_path)
		raise "Cannot encrypt #{file_path}. File does not exist" unless File.exist?(file_path)
		encrypt_with_kingslayer(password, file_path)
	end

	def decrypt(password_or_key, file_path)
		raise "Cannot decrypt #{file_path}. File does not exist" unless File.exist?(file_path)
		decrypt_with_kingslayer(password_or_key, file_path)
	end

	private

	def encrypt_with_kingslayer(password, file_path)
		opts = password ? { password: password, iter: PBKDF2_ITERATIONS } : {}
		ks = Kingslayer::AES.new(opts)
		ks.encrypt_file(file_path, file_path+encrypted_file_suffix)
		ks.password
	end

	def decrypt_with_kingslayer(password_or_key, file_path)
		begin
			ks = Kingslayer::AES.new(password: password_or_key)
			ks.decrypt_file(file_path, file_path+'.dec')
		rescue
			ks = Kingslayer::AES.new(password: password_or_key, iter: PBKDF2_ITERATIONS)
			ks.decrypt_file(file_path, file_path+'.dec')
		end
	end
end
