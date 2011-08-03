Sprockets::Environment.class_eval do
  alias_method :original_initialize, :initialize
  
  def initialize(root = '.')
    original_initialize(root)

    # Enable fingerprinting by default
    @fingerprinting_enabled = true
    
    yield self if block_given?
  end
end
