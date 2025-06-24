require 'rack/test'
require 'rspec'
require 'json'

# Set the RACK_ENV to test
ENV['RACK_ENV'] = 'test'

# Require the main application file
require File.expand_path '../app.rb', __dir__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end # For testing Sinatra part
  # For Grape, Rack::Test will automatically pick it up when mounted in Sinatra
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
