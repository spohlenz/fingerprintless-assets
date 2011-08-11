module FingerprintlessAssets
  module StaticCompilation
    def precompile(*paths)
      raise "missing static root" unless static_root

      manifest = {}
      paths.each do |path|
        files.each do |logical_path|
          next unless match_path?(logical_path, path)
          
          if asset = find_asset(logical_path)
            manifest[logical_path] = precompile_asset(asset)
          end
        end
      end
      manifest
    end
    
    def precompile_asset(asset)
      if fingerprint_path?(asset.logical_path)
        attributes  = attributes_for(asset.logical_path)
        digest_path = attributes.path_with_fingerprint(asset.digest)
        path        = digest_path
      else
        path        = asset.logical_path
      end

      filename = static_root.join(path)

      # Ensure directory exists
      FileUtils.mkdir_p filename.dirname

      # Write file
      asset.write_to(filename)

      # Write compressed file if its a bundled asset like .js or .css
      asset.write_to("#{filename}.gz") if asset.is_a?(Sprockets::BundledAsset)

      path
    end
  end
end

Sprockets::Base.send(:include, FingerprintlessAssets::StaticCompilation)
