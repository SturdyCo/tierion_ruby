require 'bundler/setup'
Bundler.setup

require 'tierion'
require 'vcr'
require 'webmock'
require 'dotenv'
require_relative 'support/account_transaction'

Dotenv.load

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
end
