require "sprockets_test"

class AssetTest < Sprockets::TestCase
  def self.test(name, &block)
    define_method("test #{name.inspect}", &block)
  end
  
  def setup
    @env = Sprockets::Environment.new
    @env.append_path(fixture_path('asset'))

    @asset = @env['POW.png']
  end
  
  test "digest_path with fingerprinting enabled returns the asset path with fingerprint" do
    digest = @asset.digest
    assert_equal "POW-#{digest}.png", @asset.digest_path
  end
  
  test "digest_path with fingerprinting disabled returns the asset's logical path" do
    @env.fingerprinting_enabled = false
    assert_equal "POW.png", @asset.digest_path
  end
end
