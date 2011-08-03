Sprockets::Index.class_eval do
  alias_method :original_initialize, :initialize
  
  def initialize(environment)
    original_initialize(environment)

    # Inherit fingerprinting values from environment
    @fingerprinting_enabled    = environment.fingerprinting_enabled?
    @fingerprinting_exclusions = environment.fingerprinting_exclusions
  end
end
