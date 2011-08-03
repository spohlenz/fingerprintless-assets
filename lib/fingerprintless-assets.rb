require "sprockets"
require 'sprockets/base'

require "fingerprintless_assets/monkey_patches/configuration"
require "fingerprintless_assets/monkey_patches/environment"
require "fingerprintless_assets/monkey_patches/index"
require "fingerprintless_assets/monkey_patches/server"
require "fingerprintless_assets/monkey_patches/static_compilation"
require "fingerprintless_assets/monkey_patches/utils"

require "fingerprintless_assets/railtie" if defined?(Rails)
