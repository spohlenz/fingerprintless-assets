module FingerprintlessAssets
  module Utils
    def match_path?(path, match)
      if match.is_a?(Regexp)
        # Match path against `Regexp`
        match.match(path)
      else
        # Otherwise use fnmatch glob syntax
        File.fnmatch(match.to_s, path)
      end
    end
  end
end

Sprockets::Base.send(:include, FingerprintlessAssets::Utils)
