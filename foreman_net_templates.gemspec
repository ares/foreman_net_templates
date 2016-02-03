require File.expand_path('../lib/foreman_net_templates/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_net_templates'
  s.version     = ForemanNetTemplates::VERSION
  s.date        = Date.today.to_s
  s.authors     = ['Marek Hulan', 'Julien Pivotto', 'Ewoud Kohl']
  s.email       = ['mhulan@redhat.com']
  s.homepage    = 'https://github.com/theforeman/foreman_net_templates'
  s.summary     = 'Adds helpers to configure networking during provisioning'
  # also update locale/gemspec.rb
  s.description = 'Adds helpers to configure networking during provisioning'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
