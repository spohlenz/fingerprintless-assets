Gem::Specification.new do |s|
  s.name = "fingerprintless-assets"
  s.version = "1.0.pre2"
  s.summary = "Fingerprinting controls for the Rails 3.1 asset pipeline."
  s.description = "Adds asset fingerprinting configuration options to Rails and Sprockets so that paths can be excluded from fingerprinting."
  s.files = Dir["README.md", "lib/**/*.rb"]
  s.authors = ["Sam Pohlenz"]
  s.email = "sam@sampohlenz.com"
  
  s.add_dependency "sprockets", "~> 2.0.0.beta.15"
end
