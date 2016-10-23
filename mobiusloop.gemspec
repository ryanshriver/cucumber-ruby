# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'mobiusloop'
  s.version     = File.read(File.expand_path("../lib/mobiusloop/version", __FILE__))
  s.authors     = ["Ryan Shriver"]
  s.description = 'mobiusloop provides continuous feedback to people on whether they are building the right things'
  s.summary     = "mobiusloop-#{s.version}"
  s.email       = 'ryanshriver@mac.com'
  s.license     = 'MIT'
  s.homepage    = "http://mobiusloop.com"
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9.3"
  s.add_dependency 'cucumber-core', '~> 1.4', '>= 1.4.0'
  s.add_dependency 'builder', '~> 2.1', '>= 2.1.2'
  s.add_dependency 'diff-lcs', '~> 1.1', '>= 1.1.3'
  s.add_dependency 'gherkin', '~> 3.2', '>= 3.2'
  s.add_dependency 'multi_json', '>= 1.7.5', '< 2.0'
  s.add_dependency 'multi_test', '~> 0.1', '>= 0.1.2'
  s.add_dependency 'cucumber-wire', '~> 0.0.1', '>= 0.0.1'
  s.add_development_dependency 'aruba', '~> 0.6.1'
  s.add_development_dependency 'json', '~> 1.7'
  s.add_development_dependency 'nokogiri', '~> 1.5'
  s.add_development_dependency 'rake', '~> 11.1', '>= 11.1'
  s.add_development_dependency 'simplecov', '~> 0.6', '>= 0.6.2'
  s.add_development_dependency 'coveralls', '~> 0.7'
  s.add_development_dependency 'syntax', '~> 1.0', '>= 1.0.0'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'rspec', '~> 3.0', '>= 3.0'

  # For Documentation:
  s.add_development_dependency 'bcat', '~> 0.6.2'
  s.add_development_dependency 'kramdown', '~> 0.14'
  s.add_development_dependency 'yard', '~> 0.8.0'

  # Needed for examples (rake examples)
  s.add_development_dependency 'capybara', '~> 2.1', '>= 2.1'
  s.add_development_dependency 'rack-test', '~> 0.6', '>= 0.6.1'
  s.add_development_dependency 'sinatra', '~> 1.3', '>= 1.3.2'

  # Added by Mobius
  s.add_dependency 'colorize', '~> 0.8.1'

  s.rubygems_version = ">= 1.6.1"
  s.files            = `git ls-files`.split("\n").reject {|path| path =~ /\.gitignore$/ }
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
