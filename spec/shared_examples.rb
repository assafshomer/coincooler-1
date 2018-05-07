shared_examples_for "all pages" do
	it { should have_selector('header.navbar.navbar-fixed-top.navbar-inverse') }
	it { should have_link(app_title, href: root_path) }
end

shared_examples_for "app pages" do
	it { should have_link('navbar_freeze', href: freeze_path)}
	it { should have_link('navbar_upload', href: uploads_path)}
end

shared_examples_for "the freeze page" do
	it { should have_title full_title(freeze_page_title) }
	it { should have_selector('select.pulldown.large#howmany') }
	it { should have_xpath("//select[@id='howmany']/option[@selected='selected'][@value=#{KEYS_DEFAULT}]")}
	it { should have_xpath("//select[@id='ssss_n']/option[@selected='selected'][@value=#{DEFAULT_SSSN}]")}
	it { should have_xpath("//select[@id='ssss_k']/option[@selected='selected'][@value=#{DEFAULT_SSSK}]")}
	it { should have_button generate_button}
	it { should have_selector('input#keyboard.input-xxlarge') }
	it { should have_selector('select.pulldown.small#ssss_n') }
	it { should have_selector('select.pulldown.small#ssss_k') }
	it { should_not have_selector 'footer'}
end

shared_examples_for "the inspect page" do
	it { should have_title full_title(inspect_page_title) }
	it { should have_selector('h2', inspect_page_header)}
	it { should have_xpath("//input[@type='file'][@id='file']")}
	it { should have_button recover_button}
	it { should have_selector('input#keyboard.input-xxlarge') }
	it { should have_selector('textarea#shares')}
	it { should have_selector('select.pulldown.small#howmany') }
	it { should have_xpath("//select[@id='howmany']/option[@selected='selected'][@value='0']")}
	it { should have_selector('#password_share_1', visible: false)}
	it { should_not have_selector 'footer'}
end

shared_examples_for "the empty uploads page" do
	it "should have it's default setup" do
		page.should have_title full_title(uploads_title)
		page.should have_selector('span.fileinput-button', text: upload_button)
		page.should_not have_css('span.fileinput-button.disabled')
		page.should_not have_xpath("//input[@type='checkbox'][@class='toggle']")
		# page.should have_button 'Cancel upload'
		page.should_not have_button 'del_all'
		should_not have_button 'delbut'
		page.should_not have_button recover_button
		page.should_not have_selector('input#keyboard.input-xxlarge')
	end
	it { should_not have_selector 'footer'}
end

shared_examples_for "the uploads page" do
	it "should have it's default setup" do
		page.should have_title full_title(uploads_title)
		page.should have_selector('span.fileinput-button', text: upload_button)
		# page.should have_xpath("//input[@type='checkbox'][@class='toggle']")
		# page.should have_button 'Cancel upload'
		page.should have_button 'del_all'
	end
	it { should_not have_selector 'footer'}
end

shared_examples_for "it has share uploads" do
	it { should have_xpath("//input[@type='file'][@id='password_share_1']")}
	it { should have_xpath("//input[@type='file'][@id='password_share_2']")}
end

shared_examples_for "the private keys page" do
	it { should have_title full_title(private_keys_title) }
	it { should have_selector('th', text: addresses_header) }
	it { should have_selector('th', text: keys_header) }
	it { should have_selector('table.private_output#private_output') }
	it { should have_selector("td#address_1") }
	it { should have_selector("td#qr_address_1") }
	it { should have_selector("td#prvkey_wif_1") }
	it { should have_selector("td#qr_prvkey_wif_1") }
	it { should_not have_selector('div.alert.alert-hot')} unless HOT
	it { should have_selector('div.alert.alert-info')}
	it { should have_xpath("//a[@class='btn btn-qr'][@id='address_qr_btn_1']")}
	it { should have_xpath("//a[@class='btn btn-qr'][@id='prvkey_qr_btn_1']")}
	it { should have_selector ('div.alert')}
	it { should_not have_selector 'footer'}
	# it_should_behave_like 'the QR buttons are working'
end

shared_examples_for "the addresses page" do
	it { should have_title full_title(addresses_title) }
	it { should have_selector('th', text: addresses_header) }
	it { should_not have_selector('th', text: keys_header) }
	it { should have_selector('table.public_output#public_output') }
	it { should have_selector("td#address_1") }
	it { should have_selector("td#qr_address_1") }
	it { should_not have_selector("td#prvkey_wif_1") }
	it { should_not have_selector('div.alert')}	unless HOT
	it { should_not have_link 'prvkey_qr_btn_1'}
	it { should have_xpath("//a[@class='btn btn-qr'][@id='address_qr_btn_1']")}
	it { should_not have_selector 'footer'}
	# it_should_behave_like 'the QR buttons are working'
end

shared_examples_for 'it has download buttons' do
  it { should have_xpath("//button[@class='btn btn-primary dropdown-toggle']")}
  # it { should have_xpath("//button[@title='#{download_keys_title}'][@class='btn btn-primary dropdown-toggle']/img[@alt='#{download_keys_button}']")}
  # it { should have_xpath("//a[@class='btn btn-success'][@title='#{download_addresses_title}']/img[@alt='#{download_addresses_button}']")}
  it { should have_link download_encrypted_link.strip}
  it { should have_link download_non_encrypted_link.strip}
  it_should_behave_like 'it does not have download row buttons'
  it { should have_link download_password_link.strip}
end

shared_examples_for 'it does not have download buttons' do
  it { should_not have_xpath("//button[@title='#{download_keys_title}'][@class='btn btn-success dropdown-toggle']/img[@alt='#{download_keys_button}']")}
  it { should_not have_xpath("//a[@class='btn btn-success'][@title='#{download_addresses_title}']/img[@alt='#{download_addresses_button}']")}
  it { should_not have_link download_encrypted_link.strip}
  it { should_not have_link download_non_encrypted_link.strip}
  it_should_behave_like 'it has download row buttons' unless it {URI.parse(current_url).request_uri == old_inspect_addresses_path}
end

shared_examples_for 'it has download row buttons' do
	it { should have_xpath("//a[@class='btn btn-success'][@id='download_row_1']/img[@alt='#{download_row_button}']")}
end

shared_examples_for 'it does not have download row buttons' do
	it { should_not have_xpath("//a[@class='btn btn-success'][@id='download_row_1']/img[@alt='#{download_row_button}']")}
end

shared_examples_for "it failed decryption" do
	it { should_not have_content('Bitcoin Address') }
	it { should_not have_content('Private Key') }
	it { should_not have_selector('div.normal', text: '(Wallet Import Format)') }
	it { should_not have_selector("td#address_1") }
	it { should_not have_selector("td#prvkey_wif_1") }
	it { should have_selector('div.alert.alert-error', text: failed_decryption_message) }
end


shared_examples_for 'it saved the files' do
		let(:files_paths) {
			paths = []
			paths << public_addresses_file_path('csv')
			paths << private_keys_file_path('csv',false)
			paths << private_keys_file_path('csv',true)
			paths << password_shares_path(1) if $split == "yes"
			paths << password_shares_path(2) if $split == "yes"
			paths
		}
	 it "should check the file" do
		files_paths.each do |path|
			File.exist?(path).should be_true
			(File.ctime(path).to_f-Time.now.to_f).to_i.should be < 1
		end
	end
end

shared_examples_for "the QR buttons are working" do
	it { should_not have_selector('td.black')}
	describe "clicking the first QR link should generate the QR" do
		let!(:origurl) {URI.parse(current_url).request_uri}
		before { first(:link, qr_button).click  }
		it { should have_selector('td.black') }
		describe "clicking the QR code should redirect to the same page without QR" do
			before { click_link 'hide_qr' }
			it { should_not have_selector('td.black') }
			it { URI.parse(current_url).request_uri.should==origurl}
		end
	end
end

shared_examples_for "flash should go away" do
	describe "when navigating home" do
		before { click_link app_title }
		it { should_not have_selector('div.alert')}
	end
	describe "when navigating to freeze page" do
		before { click_link freeze_button }
		it { should_not have_selector('div.alert')}
	end
	describe "when navigating to the inspect page" do
		before { click_link inspect_button }
		it { should_not have_selector('div.alert')}
	end
end
