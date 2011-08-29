require "sprockets"
require 'sprockets/base'

require "fingerprintless_assets/monkey_patches/configuration"
require "fingerprintless_assets/monkey_patches/asset"
require "fingerprintless_assets/monkey_patches/environment"
require "fingerprintless_assets/monkey_patches/index"

require "fingerprintless_assets/railtie" if defined?(Rails)
