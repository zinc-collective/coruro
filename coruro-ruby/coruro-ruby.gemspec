
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "coruro/version"

Gem::Specification.new do |spec|
  spec.name          = "coruro-ruby"
  spec.version       = Coruro::VERSION
  spec.authors       = ["Zee Spencer"]
  spec.email         = ["zee@wecohere.com"]

  spec.summary       = %q{Capybara-inspired testing library for emails and notifications}
  spec.description   = %q{Capybara-inspired testing library for emails and notifications. Query sent emails and make assertions against he and make assertions against them}
  spec.homepage      = "https://github.com/wecohere/coruro"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "mail", "~> 2.7.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"
end
