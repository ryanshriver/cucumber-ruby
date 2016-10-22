require 'mobiusloop/outcome'
require 'mobiusloop/scale'
require 'mobiusloop/objective'

@name = nil
@outcome = nil
@target = nil
@target_date = nil
@baseline = nil
@baseline_date = nil


Given(/^a baseline of (\d+) "([^"]*)" on "([^"]*)"$/) do |arg1, arg2, arg3|
  @name = arg2
  @baseline = arg1
  @baseline_date = arg3
end

Given(/^a target of (\d+) "([^"]*)" by "([^"]*)"$/) do |arg1, arg2, arg3|
  @name = arg2
  @target = arg1
  @target_date = arg3
end

# Replace outcome name with scenario name (in hooks.rb)
Then(/^measure progress with "([^"]*)"$/) do |arg1|
  objective = Objective.get_current
  scale_class = arg1.gsub(/\s+/, "") # turns 'My Custom Scale' into MyCustomScale
  @outcome = Outcome.new(@name, Object::const_get(scale_class).new())
  objective.add_outcome(@outcome)

  @outcome.baseline = @baseline.to_i
  @outcome.baseline_date = @baseline_date
  @outcome.target = @target.to_i
  @outcome.target_date = @target_date
  puts @outcome.measure
  puts @outcome.report
end