require 'rubygems'
require 'active_support'
require 'active_support/test_case'

require File.join(File.dirname(__FILE__), 'generator_test_helper')
 
unless defined?(RAILS_DEFAULT_LOGGER)
  @test_log = File.join(RAILS_ROOT, 'test.log')
  RAILS_DEFAULT_LOGGER = Logger.new(@test_log)
end
 
Rails::Generator::Base.prepend_sources Rails::Generator::PathSource.new(:model_plus_generator, File.join(File.dirname(__FILE__), "..", "generators"))

class GeneratorTestCase
  
  # Asserts that the given column is not defined in the migration.
  def assert_no_generated_column(body, name)
    assert_no_match /t\.\w :#{name.to_s}/, body, "should not have column #{name.to_s} defined"
  end
  
  # Asserts that the given column is not defined in the fixture.
  def assert_no_generated_attribute(body, name)
    assert_no_match /#{name.to_s}:/, body.to_yaml, "should not have value for #{name.to_s} defined"
  end

end