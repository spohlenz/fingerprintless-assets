Sprockets::Asset.class_eval do
  alias_method :original_digest_path, :digest_path
  
  # If fingerprinting is enabled for this asset, return the logical path
  # with digest spliced in. Otherwise return the logical path only.
  def digest_path
    if environment.fingerprint_path?(logical_path)
      original_digest_path
    else
      logical_path
    end
  end
end
