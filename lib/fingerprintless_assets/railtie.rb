require 'sprockets/railtie'

module FingerprintlessAssets
  class Railtie < ::Rails::Railtie
    initializer :setup_configuration, :before => :load_environment_config do |app|
      app.config.assets.fingerprinting = ActiveSupport::OrderedOptions.new
      app.config.assets.fingerprinting.exclude = []
    end

    initializer :set_configuration_defaults do |app|
      # Unless explicitly set, enable fingerprinting if performing caching
      unless app.config.assets.fingerprinting.key?(:enabled)
        app.config.assets.fingerprinting.enabled = app.config.action_controller.perform_caching
      end
    end
    
    config.after_initialize do |app|
      # Apply configuration to the application's asset environment
      app.assets.fingerprinting_enabled    = app.config.assets.fingerprinting.enabled
      app.assets.fingerprinting_exclusions = app.config.assets.fingerprinting.exclude
    end
  end
end
