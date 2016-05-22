# Major changes since forking from Cucumber

### Update Gem Spec
cp cucumber.gemspec to mobiusloop.gemspec
Edit mobiusloop.gemspec. Hard-code version.
cp bin/cucumber bin/mobiusloop
rm bin/cucumber

### Build and Install New Gem
gem build mobiusloop.gemspec
gem install mobiusloop.version

run /usr/local/Cellar/ruby/2.2.3/bin/mobiusloop
TODO: add sym-link to /usr/local/bin as part of gem install

cd /usr/local/bin
ln -s /usr/local/Cellar/ruby/2.2.3/bin/mobiusloop mobiusloop

### Modify Cucumber
/lib/cucumber/cli/main.rb
/lib/cucumber/configuration.rb
/lib/cucumber/project_initializer.rb
 - copy gherkin-languages.json to gherkin gem

run /usr/local/Cellar/ruby/2.2.3/bin/mobiusloop --init


Verify: Should initialize new /goals directory

### Add MobiusLoop Keywords to Gherkin (english only to start)
modify gherkin-languages.json to add keywords: Objective, Problem, Outcome, Key Result


### Add MobiusLoop Domain objects
/lib/mobiusloop/Outcome.rb
/lib/mobiusloop/Scale.rb
/lib/mobiusloop/Measure.rb


### Add RSpec tests
/spec/mobiusloop/*.rb

### Add Examples
cp sample scale(s) and .goal files that run

