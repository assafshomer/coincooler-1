require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("app/helpers/**/*.rb")].each { |f| require f }
include FilesHelper
# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.include Capybara::DSL
  config.filter_run_excluding :slow => true
  config.filter_run_excluding :disabled => true

  config.before(:suite) do
    message = "Please insert a USB stick without spaces in it's name"
    fail message unless (usb_attached? || ENV['CI'].present)
    nuke_coldstorage_files
  end

  config.after(:suite) do
    nuke_coldstorage_files
  end
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
Capybara.javascript_driver = :chrome

# require 'capybara/poltergeist'
# Capybara.javascript_driver = :poltergeist

def jquery_attach_file(dom_id, path, element_name='seleniumUpload')
  page.execute_script(element_name + " = window.$('<input/>').attr({id: '"+element_name+"', type:'file'}).appendTo('body');")
  attach_file element_name, path
  page.execute_script("e = $.Event('drop'); e.originalEvent = {dataTransfer : { files : "+element_name+".get(0).files } }; $('#"+dom_id+"').trigger(e);")
  sleep 1
end

def delete_all
  # page.execute_script("$('#upload_del_all').click();$('#del_all').click();")
  # sleep 1
  visit uploads_path
  page.check('upload_del_all') if page.has_css?('input#upload_del_all')
  click_button 'del_all' if page.has_button?('del_all')
end
