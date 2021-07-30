lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name    = "fluent-plugin-rapidomize"
  spec.version = "0.1.0"
  spec.authors = ["Nisal Bandara"]
  spec.email   = ["nisal.bandara@outlook.com"]

  spec.summary       = 'Fluent output plugin for Rapidomize cloud'
  spec.description   = 'Easily send data to Rapidomize cloud apps from Fluentd'
  spec.homepage      = "https://github.com/rapidomize/fluent-plugin-rapidomize"
  spec.license       = "Apache-2.0"
  
  test_files, files  = `git ls-files -z`.split("\x0").partition do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.files         = files
  spec.executables   = files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = test_files
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2.22"
  spec.add_development_dependency "rake", "~> 13.0.3"
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency "test-unit", "~> 3.3.7"
  spec.add_runtime_dependency "fluentd", [">= 0.14.10", "< 2"]
  spec.add_runtime_dependency 'rapidomize', '~> 1.0'
  spec.add_runtime_dependency 'oj', '~> 3.12', '>= 3.12.2'
end
