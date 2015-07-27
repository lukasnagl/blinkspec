Gem::Specification.new do |s|
  s.name        = "blinkspec"
  s.version     = "0.0.1"
  s.date        = "2015-07-27"
  s.summary     = "Run your specs with blink(1) feedback."
  s.description = "Run your specs with beautiful output and blink(1) signals"
  s.authors     = ["Lukas Nagl"]
  s.email       = "lukas.nagl@innovaptor.com"
  s.homepage    = "https://github.com/j4zz/blinkspec"
  s.license     = "MIT"
  # Done with descriptive fields.
  s.rubyforge_project = "blinkspec"
  s.files       = ["bin/blinkspec"]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables << "blinkspec"
  s.require_paths = ["lib"]
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'rake', '~> 10.3'
  s.add_development_dependency 'bundler'
end