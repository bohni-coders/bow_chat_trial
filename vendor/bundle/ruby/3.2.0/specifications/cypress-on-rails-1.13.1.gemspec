# -*- encoding: utf-8 -*-
# stub: cypress-on-rails 1.13.1 ruby lib

Gem::Specification.new do |s|
  s.name = "cypress-on-rails".freeze
  s.version = "1.13.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/shakacode/cypress-on-rails/issues", "changelog_uri" => "https://github.com/shakacode/cypress-on-rails/blob/master/CHANGELOG.md", "documentation_uri" => "https://github.com/shakacode/cypress-on-rails/blob/master/README.md", "homepage_uri" => "http://github.com/shakacode/cypress-on-rails", "source_code_uri" => "http://github.com/shakacode/cypress-on-rails" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["miceportal team".freeze, "Grant Petersen-Speelman".freeze]
  s.date = "2022-06-08"
  s.description = "Integrates cypress with rails or rack applications".freeze
  s.email = ["info@miceportal.de".freeze, "grantspeelman@gmail.com".freeze]
  s.homepage = "http://github.com/shakacode/cypress-on-rails".freeze
  s.post_install_message = "The CypressDev constant is being deprecated and will be completely removed and replaced with CypressOnRails.".freeze
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Integrates cypress with rails or rack applications".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<rack>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  s.add_development_dependency(%q<railties>.freeze, [">= 3.2"])
  s.add_development_dependency(%q<factory_bot>.freeze, [">= 0"])
  s.add_development_dependency(%q<vcr>.freeze, [">= 0"])
end
