lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "shopifly/version"

Gem::Specification.new do |spec|
  spec.name          = "shopifly"
  spec.version       = Shopifly::VERSION
  spec.authors       = ["Lee Pender", "Mateo Lugo"]
  spec.email         = ["lee@lunchtimelabs.io", "lugomateo@gmail.com"]

  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = "https://github.com/lugomateo/shopifly"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "json"
  spec.add_dependency "rainbow"
  spec.add_dependency "shopify_api"
  spec.add_dependency "thor", "~> 0.20"
end
