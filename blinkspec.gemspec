Gem::Specification.new do |s|
  s.name        = "blinkspec"
  s.version     = "0.0.0"
  s.date        = "2015-07-09"
  s.summary     = "Run your specs with blink(1) feedback."
  s.description = "Run your specs with beautiful output and blink(1) signals"
  s.authors     = ["Lukas Nagl"]
  s.email       = "lukas.nagl@innovaptor.com"
  s.homepage    = "http://none.yet"
  s.license     = "MIT"
  # Done with descriptive fields.
  s.rubyforge_project = "blinkspec"
  s.files       = ["bin/blinkspec"]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables << "blinkspec"
  s.require_paths = ["lib"]
  s.add_development_dependency "rspec", '~> 3.0'
end