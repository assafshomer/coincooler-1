#!/usr/bin/env ruby
# save this file as `decrypt.rb` in the same directory where you saved the encrypted file
# type `ruby decrypt.rb` and follow the instructions
require 'base64'
require 'openssl'
`rm -f plaintext`

def decrypt(data, password, salt, iv, iterations)
  digest = OpenSSL::Digest::SHA256.new;
  length = digest.digest_length
  cipher = OpenSSL::Cipher::AES256.new('CBC');
  key = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, length, digest)
  cipher.decrypt
  cipher.key=key
  cipher.iv=iv
  File.write('plaintext', cipher.update(data) + cipher.final)
end

puts "Enter encrypted private keys file name (in this directory)"
path = "#{`pwd`.strip}/#{gets.chomp}"
puts "Enter the password you used to encrypt this file with CoinCooler"
password = gets.chomp
encrypted = File.read(path)
data = Base64.decode64(encrypted)
salt = data[8..15]
iv = data[16..31]
data = data[32..-1]

begin
  decrypt(data, password, salt, iv, 1)
rescue => e
  decrypt(data, password, salt, iv, 1_000_000)
end

puts `cat plaintext`

puts "\nThe decrypted file was saved to #{`pwd`.strip}/plaintext"
