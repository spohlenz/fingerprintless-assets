require 'sprockets_test'
require 'rack/mock'

module EnvironmentTests
  def self.test(name, &block)
    define_method("test #{name.inspect}", &block)
  end
  
  def new_environment
    Sprockets::Environment.new(".") do |env|
      env.append_path(fixture_path('default'))
      env.static_root = fixture_path('public')
      env.cache = {}
      yield env if block_given?
    end
  end

  def setup
    @env = new_environment
  end

  test "fingerprint_path? is false when fingerprinting disabled" do
    @env.fingerprinting_enabled = false
    assert !@env.fingerprint_path?("abc.js")
  end
  
  test "fingerprint_path? is true when fingerprinting enabled" do
    @env.fingerprinting_enabled = true
    assert @env.fingerprint_path?("abc.js")
  end
  
  test "fingerprint_path? is false when fingerprinting enabled but excluded by exact match" do
    @env.fingerprinting_enabled = true
    @env.fingerprinting_exclusions = ["abc.js"]
    assert !@env.fingerprint_path?("abc.js")
  end
  
  test "fingerprint_path? is false when fingerprinting enabled but excluded by glob" do
    @env.fingerprinting_enabled = true
    @env.fingerprinting_exclusions = ["abc.*"]
    assert !@env.fingerprint_path?("abc.js")
  end
  
  test "fingerprint_path? is false when fingerprinting enabled but excluded by regex" do
    @env.fingerprinting_enabled = true
    @env.fingerprinting_exclusions = [/abc\.*/]
    assert !@env.fingerprint_path?("abc.js")
  end
end

class TestEnvironment < Sprockets::TestCase
  include EnvironmentTests
  
  test "fingerprinting configuration" do
    @env = new_environment do |env|
      env.fingerprinting_enabled = true
      env.fingerprinting_exclusions = ["abc.js", /abc\..*/, "default/*"]
    end
    
    assert @env.fingerprinting_enabled?
    assert_equal ["abc.js", /abc\..*/, "default/*"], @env.fingerprinting_exclusions
  end
end

class TestIndex < Sprockets::TestCase
  include EnvironmentTests

  def setup
    @env = new_environment.index
  end
  
  test "fingerprinting configuration is carried across to index" do
    @env = new_environment do |env|
      env.fingerprinting_enabled = true
      env.fingerprinting_exclusions = ["abc.js", /abc\..*/, "default/*"]
    end

    index = @env.index
    assert index.fingerprinting_enabled?
    assert_equal ["abc.js", /abc\..*/, "default/*"], index.fingerprinting_exclusions
  end
end
