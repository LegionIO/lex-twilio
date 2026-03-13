# frozen_string_literal: true

require_relative 'lib/legion/extensions/twilio/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-twilio'
  spec.version       = Legion::Extensions::Twilio::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX::Twilio'
  spec.description   = 'LEX::Twilio'
  spec.homepage      = 'https://github.com/LegionIO/lex-twilio'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/LegionIO/lex-twilio'
  spec.metadata['documentation_uri'] = 'https://github.com/LegionIO/lex-twilio'
  spec.metadata['changelog_uri'] = 'https://github.com/LegionIO/lex-twilio'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/LegionIO/lex-twilio/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.require_paths = ['lib']
end
