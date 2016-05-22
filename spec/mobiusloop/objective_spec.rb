require 'rspec'
require 'mobiusloop/objective'

describe 'Objective' do

  it 'should set name in initialize' do
    objective = Objective.new("My goal is for us to...")
    expect(objective.name).to eql("My goal is for us to...")
  end
end