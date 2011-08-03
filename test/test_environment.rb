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
  
  test "path for asset with fingerprinting disabled" do
    @env.fingerprinting_enabled = false
    assert_equal "/gallery.js", @env.path("gallery.js")
  end

  test "path for asset with fingerprinting exclusion" do
    @env.fingerprinting_exclusions = ["gallery.js"]
    assert_equal "/gallery.js", @env.path("gallery.js")
  end

  test "path for asset with fingerprinting enabled" do
    digest = @env["gallery.js"].digest
    assert_equal "/gallery-#{digest}.js", @env.path("gallery.js")
    assert_equal "/gallery-#{digest}.js", @env.path("/gallery.js")
    assert_equal "/assets/gallery-#{digest}.js", @env.path("gallery.js", false, "/assets")
  end

  test "url for asset with fingerprinting disabled" do
    @env.fingerprinting_enabled = false
    env = Rack::MockRequest.env_for("/")
    
    assert_equal "http://example.org/gallery.js",
      @env.url(env, "gallery.js")
  end

  test "url for asset with fingerprinting exlusions" do
    @env.fingerprinting_exclusions = ["gallery.js"]
    env = Rack::MockRequest.env_for("/")
    
    assert_equal "http://example.org/gallery.js",
      @env.url(env, "gallery.js")
  end

  test "url for asset with fingerprinting enabled" do
    env = Rack::MockRequest.env_for("/")
    digest = @env["gallery.js"].digest

    assert_equal "http://example.org/gallery-#{digest}.js",
      @env.url(env, "gallery.js")
    assert_equal "http://example.org/gallery-#{digest}.js",
      @env.url(env, "/gallery.js")
    assert_equal "http://example.org/assets/gallery-#{digest}.js",
      @env.url(env, "gallery.js", false, "assets")
  end
  
  test "precompile with fingerprinting disabled" do
    @env.fingerprinting_enabled = false

    filename    = fixture_path("public/gallery.js")
    filename_gz = "#{filename}.gz"

    sandbox filename, filename_gz do
      assert !File.exist?(filename)
      @env.precompile("gallery.js")
      assert File.exist?(filename)
      assert File.exist?(filename_gz)
    end
  end

  test "precompile with fingerprinting exclusion" do
    @env.fingerprinting_exclusions = ["gallery.js"]

    filename    = fixture_path("public/gallery.js")
    filename_gz = "#{filename}.gz"

    sandbox filename, filename_gz do
      assert !File.exist?(filename)
      @env.precompile("gallery.js")
      assert File.exist?(filename)
      assert File.exist?(filename_gz)
    end
  end

  test "precompile with fingerprinting enabled" do
    digest      = @env["gallery.js"].digest
    filename    = fixture_path("public/gallery-#{digest}.js")
    filename_gz = "#{filename}.gz"

    sandbox filename, filename_gz do
      assert !File.exist?(filename)
      @env.precompile("gallery.js")
      assert File.exist?(filename)
      assert File.exist?(filename_gz)
    end
  end

  test "precompile glob with fingerprinting disabled" do
    @env.fingerprinting_enabled = false
    dirname = fixture_path("public/mobile")

    sandbox dirname do
      assert !File.exist?(dirname)
      @env.precompile("mobile/*")

      assert File.exist?(dirname)
      [nil, '.gz'].each do |gzipped|
        assert File.exist?(File.join(dirname, "a.js#{gzipped}"))
        assert File.exist?(File.join(dirname, "b.js#{gzipped}"))
        assert File.exist?(File.join(dirname, "c.css#{gzipped}"))
      end
    end
  end

  test "precompile glob with fingerprinting exclusion" do
    @env.fingerprinting_exclusions = ["mobile/*"]
    dirname = fixture_path("public/mobile")

    sandbox dirname do
      assert !File.exist?(dirname)
      @env.precompile("mobile/*")

      assert File.exist?(dirname)
      [nil, '.gz'].each do |gzipped|
        assert File.exist?(File.join(dirname, "a.js#{gzipped}"))
        assert File.exist?(File.join(dirname, "b.js#{gzipped}"))
        assert File.exist?(File.join(dirname, "c.css#{gzipped}"))
      end
    end
  end

  test "precompile glob with fingerprinting enabled" do
    dirname = fixture_path("public/mobile")

    a_digest = @env["mobile/a.js"].digest
    b_digest = @env["mobile/b.js"].digest
    c_digest = @env["mobile/c.css"].digest

    sandbox dirname do
      assert !File.exist?(dirname)
      @env.precompile("mobile/*")

      assert File.exist?(dirname)
      [nil, '.gz'].each do |gzipped|
        assert File.exist?(File.join(dirname, "a-#{a_digest}.js#{gzipped}"))
        assert File.exist?(File.join(dirname, "b-#{b_digest}.js#{gzipped}"))
        assert File.exist?(File.join(dirname, "c-#{c_digest}.css#{gzipped}"))
      end
    end
  end

  test "precompile regexp with fingerprinting disabled" do
    @env.fingerprinting_enabled = false
    dirname = fixture_path("public/mobile")

    sandbox dirname do
      assert !File.exist?(dirname)
      @env.precompile(/mobile\/.*/)

      assert File.exist?(dirname)
      [nil, '.gz'].each do |gzipped|
        assert File.exist?(File.join(dirname, "a.js#{gzipped}"))
        assert File.exist?(File.join(dirname, "b.js#{gzipped}"))
        assert File.exist?(File.join(dirname, "c.css#{gzipped}"))
      end
    end
  end

  test "precompile regexp with fingerprinting exclusion" do
    @env.fingerprinting_exclusions = [/mobile\/.*/]
    dirname = fixture_path("public/mobile")

    sandbox dirname do
      assert !File.exist?(dirname)
      @env.precompile(/mobile\/.*/)

      assert File.exist?(dirname)
      [nil, '.gz'].each do |gzipped|
        assert File.exist?(File.join(dirname, "a.js#{gzipped}"))
        assert File.exist?(File.join(dirname, "b.js#{gzipped}"))
        assert File.exist?(File.join(dirname, "c.css#{gzipped}"))
      end
    end
  end

  test "precompile regexp with fingerprinting enabled" do
    dirname = fixture_path("public/mobile")

    a_digest = @env["mobile/a.js"].digest
    b_digest = @env["mobile/b.js"].digest
    c_digest = @env["mobile/c.css"].digest

    sandbox dirname do
      assert !File.exist?(dirname)
      @env.precompile(/mobile\/.*/)

      assert File.exist?(dirname)
      [nil, '.gz'].each do |gzipped|
        assert File.exist?(File.join(dirname, "a-#{a_digest}.js#{gzipped}"))
        assert File.exist?(File.join(dirname, "b-#{b_digest}.js#{gzipped}"))
        assert File.exist?(File.join(dirname, "c-#{c_digest}.css#{gzipped}"))
      end
    end
  end

  test "precompile static asset with fingerprinting disabled" do
    @env.fingerprinting_enabled = false
    filename = fixture_path("public/hello.txt")

    sandbox filename do
      assert !File.exist?(filename)
      @env.precompile("hello.txt")
      assert File.exist?(filename)
      assert !File.exist?("#{filename}.gz")
    end
  end

  test "precompile static asset with fingerprinting exclusion" do
    @env.fingerprinting_exclusions = ["hello.txt"]
    filename = fixture_path("public/hello.txt")

    sandbox filename do
      assert !File.exist?(filename)
      @env.precompile("hello.txt")
      assert File.exist?(filename)
      assert !File.exist?("#{filename}.gz")
    end
  end

  test "precompile static asset with fingerprinting enabled" do
    digest   = @env["hello.txt"].digest
    filename = fixture_path("public/hello-#{digest}.txt")

    sandbox filename do
      assert !File.exist?(filename)
      @env.precompile("hello.txt")
      assert File.exist?(filename)
      assert !File.exist?("#{filename}.gz")
    end
  end
end

class TestEnvironment < Sprockets::TestCase
  include EnvironmentTests
end

class TestIndex < Sprockets::TestCase
  include EnvironmentTests

  def new_environment
    super.index
  end
end
