require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FilesHelper

describe "Freezers" do
	subject { page }
	before do
		nuke_coldstorage_dirs_on_usb
	  visit freeze_path
	end
	describe "submitting should redirect to view if a positive number is requested"  do
		before do
			select 2, from: :howmany
			fill_in 'password', with: 'supercali'
		  click_button generate_button
		end
		it_should_behave_like 'it saved the files'
		it_should_behave_like 'the private keys page'
		it_should_behave_like 'the QR buttons are working'
		it_should_behave_like 'it has download buttons'
		it { should_not have_link 'password_share_1'}
		it { should have_selector('div#show_password', text: 'supercali') }
		describe "and should show the correct number of rows" do
			it { should have_selector("td#qr_address_2") }
			it { should have_selector("td#qr_prvkey_wif_2") }
		end
	end
	describe "submitting without password should default to a strong password"  do
		before do
			select 1, from: :howmany
			check 'split'
		  click_button generate_button
		end
		it_should_behave_like 'the private keys page'
		it_should_behave_like 'it has download buttons'
		it { should have_link 'password_share_1'}
		describe "the number of share links should be #{DEFAULT_SSSN} (default)" do
			it { should have_link "password_share_#{DEFAULT_SSSN}"}
		end
	end
	describe "views" do
		before do
			select 2, from: :howmany
			fill_in 'password', with: 'moooohaha'
			check('split')
			select 3, from: :ssss_n
			select 2, from: :ssss_k
		  click_button generate_button
		end
		describe "private keys view" do
			describe "should show in HTML the content of private_keys.csv" do
				let!(:data) { CSV.read(private_keys_file_path('csv',false)) }
				before { visit new_keys_path }
				it_should_behave_like 'the private keys page'
				it { should have_link 'password_share_1'}
				it { should have_selector('td.text_pubkey#address_1', text: data[1][1]) }
				it { should have_selector('td.text_prvkey#prvkey_wif_1', text: data[1][2]) }
				describe "and redirect home if there is no such file" do
					before do
					  clear_coldstorage_files_locally
					  visit new_keys_path
					end
					it { should have_title(home_title) }
				end
			end
			describe "download addresses link should" do
				describe "save the file to the usb location" do
					before do
						nuke_coldstorage_dirs_on_usb
					  click_link download_addresses_button
					end
					specify{File.exist?(public_directory_path(true)+addresses_file_name+'.csv').should be_true }
				end
				describe "and redirect home if no file" do
					before do
					  clear_coldstorage_files_locally
					  click_link download_addresses_button
					end
					it { should have_title(home_title) }
					it { should have_selector('div.alert.alert-error', text: missing_file_error) }
				end
			end
			describe "download UNencrypted link should" do
				describe "save the file to the usb location" do
					before do
						nuke_coldstorage_dirs_on_usb
					  click_link download_non_encrypted_link.strip
					end
					specify{File.exist?(unencrypted_directory_path(true)+private_keys_file_name+'.csv').should be_true }
				end
				describe "and redirect home if no file" do
					before do
					  clear_coldstorage_files_locally
					  click_link download_non_encrypted_link.strip
					end
					it { should have_title(home_title) }
					it { should have_selector('div.alert.alert-error', text: missing_file_error) }
				end
			end
			describe "download encrypted link should" do
				describe "save the file to the usb location" do
					before do
						nuke_coldstorage_dirs_on_usb
					  click_link download_encrypted_link.strip
					end
					specify{File.exist?(encrypted_directory_path(true)+private_keys_file_name+'.csv'+encrypted_file_suffix).should be_true }
				end
				describe "and redirect home if no file" do
					before do
					  clear_coldstorage_files_locally
					  click_link download_encrypted_link.strip
					end
					it { should have_title(home_title) }
					it { should have_selector('div.alert.alert-error', text: missing_file_error) }
				end
			end
			describe "download shares link should" do
				describe "save the share file to the usb location" do
					before do
						nuke_coldstorage_dirs_on_usb
					  click_link 'password_share_1'
					end
					specify{File.exist?(encrypted_directory_path(true)+password_share_file_name+'_1.csv').should be_true }
				end
				describe "and redirect home if no file" do
					before do
					  clear_coldstorage_files_locally
					  click_link 'password_share_1'
					end
					it { should have_title(home_title) }
					it { should have_selector('div.alert.alert-error', text: missing_file_error) }
				end
			end
			describe "download password link should" do
				describe "save the password file to the usb location" do
					before do
						nuke_coldstorage_dirs_on_usb
					  click_link download_password_link.strip
					end
					specify{File.exist?(encrypted_directory_path(true)+password_file_name+'.csv').should be_true }
				end
				describe "and redirect home if no file" do
					before do
					  clear_coldstorage_files_locally
					  click_link download_password_link.strip
					end
					it { should have_title(home_title) }
					it { should have_selector('div.alert.alert-error', text: missing_file_error) }
				end
			end
			describe "the number of share links should be 3" do
				it { should have_link 'password_share_3'}
				it { should_not have_link 'password_share_4'}
				describe "as is the number of shares files" do
					3.times do |n|
						specify{File.exist?(password_shares_path(n+1)).should be_true }
					end
					specify{File.exist?(password_shares_path(4)).should be_false }
				end
			end
		end
	end
	describe "should not die on a big dispatch" do
		before do
			select 15, from: :howmany
		  click_button generate_button
		end
		it_should_behave_like 'the private keys page'
		it_should_behave_like 'it has download buttons'
	end
	after(:all) do
		nuke_coldstorage_dirs_on_usb
	end
end
