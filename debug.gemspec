# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'debug/version'

Gem::Specification.new do |spec|
  spec.name          = "debug"
  spec.version       = Debug::VERSION
  spec.authors       = ["Matt Hoyle"]
  spec.email         = ["matt@deployable.co"]
  spec.summary       = %q{debug like nodes debug, but rubyish}
  spec.description   = %q{An implementation of nodes debug but applying ruby's concept of the world to the idea}
  spec.homepage      = "http://code.deployable.co/ruby/debug"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "pry-byebug"
end
