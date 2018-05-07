require 'spec_helper'
require 'openssl'
include PathHelper

describe CryptoHelper do
	let!(:tmp) { file_fixtures_directory + 'tmp/' }
	let!(:key) { OpenSSL::Cipher::AES256.new(:CBC).random_key.unpack('H*')[0] }
	before do
	  FileUtils.mkdir tmp unless File.directory?(tmp)
	  FileUtils.chmod 'a+w', tmp
	  File.write(tmp+'foo', 'testing 123')
	end
	describe "Raise an error if file not there" do
		it {expect {encrypt('foo','bar')}.to raise_error /file does not exist/i}
		it {expect {decrypt('foo','bar')}.to raise_error /file does not exist/i}
	end
	describe "encryption" do
		describe "with password" do
			it "should return the password" do
				encrypt('password', tmp+'foo').should == 'password'
			end
			describe "If file not there" do
				it "should raise an error" do
					expect {encrypt('foo','bar')}.to raise_error /file does not exist/i
				end
			end
			describe "If file there" do
				describe "encryption should not raise an error" do
					it { expect {encrypt('password',tmp+'foo')}.not_to raise_error }
				end
				describe "after encryption the encrypted file should be there" do
					before { encrypt('foobar', tmp+'foo') }
					it {File.exist?(tmp+'foo'+encrypted_file_suffix).should be_true	}
					describe "and should start with Salted__" do
						it { Base64.decode64(File.read(tmp+'foo'+encrypted_file_suffix))[0..7].should == 'Salted__' }
					end
				end
			end
		end
		describe "without password" do
			it "should return a random key" do
				encrypt(nil, tmp+'foo').match(/^\h{64}$/).to_s.length.should == 64
			end
			describe "If file not there" do
				it "should raise an error" do
					expect {encrypt(nil,'bar')}.to raise_error /file does not exist/i
				end
			end
			describe "If file there" do
				describe "encryption should not raise an error" do
					it { expect {encrypt(nil,tmp+'foo')}.not_to raise_error }
				end
				describe "after encryption the encrypted file should be there" do
					before { encrypt(nil, tmp+'foo') }
					it {File.exist?(tmp+'foo'+encrypted_file_suffix).should be_true	}
					describe "and should start with Salted__" do
						it { Base64.decode64(File.read(tmp+'foo'+encrypted_file_suffix))[0..7].should == 'Salted__' }
					end
				end
			end
		end
	end
	describe "decryption" do
		describe "with a password" do
			before { encrypt('password', tmp+'foo') }
			describe "If file not there" do
				it "should raise an error" do
					expect {decrypt('foo','bar')}.to raise_error /file does not exist/i
				end
			end
			describe "If file there" do
				describe "decryption should not raise an error" do
					it { expect {decrypt('password',tmp+'foo'+encrypted_file_suffix)}.not_to raise_error }
				end
				describe "after decryption the decrypted file should be there" do
					before { decrypt('password', tmp+'foo'+encrypted_file_suffix) }
					it {File.exist?(tmp+'foo'+decrypted_file_suffix).should be_true	}
					describe "and should be identical to the original file" do
						it { File.read(tmp+'foo'+decrypted_file_suffix).should == 'testing 123' }
					end
				end
			end
		end
		describe "with a key" do
			before { encrypt(key, tmp+'foo') }
			describe "If file not there" do
				it "should raise an error" do
					expect {decrypt(key,'bar')}.to raise_error /file does not exist/i
				end
			end
			describe "If file there" do
				describe "decryption should not raise an error" do
					it { expect {decrypt(key,tmp+'foo'+encrypted_file_suffix)}.not_to raise_error }
				end
				describe "after decryption the decrypted file should be there" do
					before { decrypt(key, tmp+'foo'+encrypted_file_suffix) }
					it {File.exist?(tmp+'foo'+decrypted_file_suffix).should be_true	}
					describe "and should be identical to the original file" do
						it { File.read(tmp+'foo'+decrypted_file_suffix).should == 'testing 123' }
					end
				end
			end
		end
		describe "without a password" do
			let!(:randkey) { encrypt(nil, tmp+'foo') }
			describe "If file there" do
				describe "decryption should not raise an error" do
					it { expect {decrypt(randkey,tmp+'foo'+encrypted_file_suffix)}.not_to raise_error }
				end
				describe "after decryption the decrypted file should be there" do
					before { decrypt(randkey, tmp+'foo'+encrypted_file_suffix) }
					it {File.exist?(tmp+'foo'+decrypted_file_suffix).should be_true	}
					describe "and should be identical to the original file" do
						it { File.read(tmp+'foo'+decrypted_file_suffix).should == 'testing 123' }
					end
				end
			end
		end
	end

	after do
		FileUtils.rm Dir[tmp+'*']
	end

end
