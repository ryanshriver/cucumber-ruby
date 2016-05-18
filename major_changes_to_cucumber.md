# Update Gem Spec
cp cucumber.gemspec mobiusloop.gemspec and modify. Put version in .gemspec
cp bin/cucumber bin/mobiusloop
rm bin/cucumber

# Build and Install New Gem
gem build mobiusloop.gemspec
gem install mobiusloop.version

run /usr/local/Cellar/ruby/2.2.3/bin/mobiusloop

TODO: add sym-link to /usr/local/bin

# Modify Cucumber
/lib/cucumber/cli/main.rb
/lib/cucumber/configuration.rb
/lib/cucumber/project_initializer.rb


run /usr/local/Cellar/ruby/2.2.3/bin/mobiusloop --init

# Update Gherkin
gem_home=`gem environment gemdir`
cp gherkin-languages.json $gem_home/gems/gherkin-?.?.?/lib/gherkin

