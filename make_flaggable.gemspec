# -*- encoding: utf-8 -*-
require File.expand_path("../lib/make_flaggable/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "make_flaggable"
  s.version     = MakeFlaggable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kai Schlamp"]
  s.email       = ["schlamp@gmx.de"]
  s.homepage    = "http://github.com/medihack/make_flaggable"
  s.summary     = "Rails 3 flagging extension"
  s.description = "A user-centric flagging extension for Rails 3 applications."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "make_flaggable"

  s.add_dependency "activerecord", ['>= 3.0', '< 4.2']
  s.add_development_dependency "bundler", ['>= 1.0.0', '<= 1.4']
  s.add_development_dependency "rspec", "~>2.14.0"
  s.add_development_dependency "database_cleaner", "1.0.1"
  s.add_development_dependency "generator_spec", "~> 0.9.0"
  s.add_development_dependency "rake", ">= 0.9.2"
  s.add_development_dependency 'appraisal'

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
