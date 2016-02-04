Gem::Specification.new do |s|
  s.name        = 'tierion'
  s.version     = '0.0.0'
  s.date        = '2016-01-05'
  s.summary     = 'Tierion API wrapper'
  s.description = 'Tierion API wrapper'
  s.authors     = ['Garrett Martin']
  s.email       = 'garrett@sturdy.work'
  s.files       = ['lib/tierion.rb']
  # s.homepage    = 'http://rubygems.org/gems/hola'
  s.license     = 'MIT'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_runtime_dependency     'httparty'
end
