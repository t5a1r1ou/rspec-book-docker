# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'
require 'paperclip/matchers'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Capybara.server_host = Socket.ip_address_list.detect(&:ipv4_private?).ip_address
Capybara.server_port = 3001

Capybara.register_driver :selenium_remote do |app|
  url = 'http://chrome:4444/wd/hub'
  opts = { desired_capabilities: :chrome, browser: :remote, url: url }
  driver = Capybara::Selenium::Driver.new(app, opts)
end

Capybara.javascript_driver = :selenium_remote

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include RequestSpecHelper, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Paperclip::Shoulda::Matchers
  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/test_uploads/"])
  end
  # config.before(:each, type: :feature) do
  #   driven_by :rack_test
  # end
  # config.before(:each, type: :feature, js: true) do
  #   driven_by :selenium_remote
  #   host! "http://#{Capybara.server_host}:#{Capybara.server_port}"
  # end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
