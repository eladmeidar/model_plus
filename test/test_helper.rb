require 'rubygems'
require 'active_support'
require 'active_support/test_case'

require File.join(File.dirname(__FILE__), 'generator_test_helper')
 
unless defined?(RAILS_DEFAULT_LOGGER)
  @test_log = File.join(RAILS_ROOT, 'test.log')
  RAILS_DEFAULT_LOGGER = Logger.new(@test_log)
end
 
Rails::Generator::Base.prepend_sources Rails::Generator::PathSource.new(:model_plus_generator, File.join(File.dirname(__FILE__), "..", "generators"))

 
