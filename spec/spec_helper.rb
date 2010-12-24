ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require 'rspec'
require File.expand_path("../../../../../config/environment", __FILE__)

#require File.dirname(__FILE__) + '/../init'

RSpec.configure do |config|
  config.mock_with :rspec
end
