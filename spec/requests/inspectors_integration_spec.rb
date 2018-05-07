require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FilesHelper

describe "Inspectors" do
	subject { page }
	before do
		nuke_coldstorage_dirs_on_usb
	  visit freeze_path
	end

	describe "Full circle encryption and decryption with ssss should fail if not enough shares" do
		before do
			select 2, from: :howmany
			select 6, from: :ssss_n
			select 4, from: :ssss_k
		  click_button generate_button
		  visit old_inspect_path
		  select 3, from: :howmany
		  attach_file "file", private_keys_file_path('csv',true)
		  attach_file "password_share_1", password_shares_path(1,false)
		  attach_file "password_share_2", password_shares_path(2,false)
		  attach_file "password_share_3", password_shares_path(3,false)
		  click_button recover_button
		end
		# it_should_behave_like 'the inspect page'
		it { should have_selector('div.alert.alert-error', text: wrong_password_flash)}
	end

	describe "Full circle encryption and decryption with ssss should succeed if enough shares" do
		before do
			select 2, from: :howmany
			select 6, from: :ssss_n
			select 4, from: :ssss_k
		  click_button generate_button
		  visit old_inspect_path
		  select 4, from: :howmany
		  attach_file "file", private_keys_file_path('csv',true)
		  attach_file "password_share_1", password_shares_path(1,false)
		  attach_file "password_share_2", password_shares_path(2,false)
		  attach_file "password_share_3", password_shares_path(3,false)
		  attach_file "password_share_4", password_shares_path(4,false)
		  click_button recover_button
		end
		it_should_behave_like 'the private keys page'
		it { should_not have_selector('div.alert.alert-error', text: wrong_password_flash)}
	end

	describe "Full circle encryption and decryption with password should fails if wrong " do
		before do
			select 2, from: :howmany
			fill_in 'password', with: 'moooohaha'
		  click_button generate_button
		  visit old_inspect_path
		  fill_in 'password', with: 'mooo0haha'
		  attach_file "file", private_keys_file_path('csv',true)
		  click_button recover_button
		end
		# it_should_behave_like 'the inspect page'
		it { should have_selector('div.alert.alert-error', text: wrong_password_flash)}
	end

	describe "Full circle encryption and decryption with password should succeed if correct " do
		before do
			select 2, from: :howmany
			fill_in 'password', with: 'moooohaha'
		  click_button generate_button
		  visit old_inspect_path
		  fill_in 'password', with: 'moooohaha'
		  attach_file "file", private_keys_file_path('csv',true)
		  click_button recover_button
		end
		it_should_behave_like 'the private keys page'
		it { should_not have_selector('div.alert.alert-error', text: wrong_password_flash)}
	end

	describe "Full circle encryption and decryption with password should succeed if correct upto stripping leading and tralinig spaces " do
		before do
			select 2, from: :howmany
			fill_in 'password', with: ' moooohaha  '
		  click_button generate_button
		  visit old_inspect_path
		  fill_in 'password', with: '  moooohaha '
		  attach_file "file", private_keys_file_path('csv',true)
		  click_button recover_button
		end
		it_should_behave_like 'the private keys page'
		it { should_not have_selector('div.alert.alert-error', text: wrong_password_flash)}
	end

	after(:all) do
		nuke_coldstorage_dirs_on_usb
	end
end
