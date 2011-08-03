module FingerprintlessAssets
  module Server
    def path(logical_path, _ignored_fingerprint = true, prefix = nil)
      super(logical_path, fingerprint_path?(logical_path), prefix)
    end
  end
end

Sprockets::Base.send(:include, FingerprintlessAssets::Server)
