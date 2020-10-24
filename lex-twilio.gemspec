require_relative 'lib/legion/extensions/twilio/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-twilio'
  spec.version       = Legion::Extensions::Twilio::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX::Twilio'
  spec.description   = 'LEX::Twilio'
  spec.homepage      = 'https://bitbucket.org/legion-io/lex-twilio'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://bitbucket.org/legion-io/lex-twilio'
  spec.metadata['documentation_uri'] = 'https://legionio.atlassian.net/wiki/spaces/LEX/pages/614858774'
  spec.metadata['changelog_uri'] = 'https://legionio.atlassian.net/wiki/spaces/LEX/pages/612270137'
  spec.metadata['bug_tracker_uri'] = 'https://bitbucket.org/legion-io/lex-twilio/issues'
  spec.require_paths = ['lib']
end
