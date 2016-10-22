require 'rspec'

require 'mobiusloop/outcome'
require 'mobiusloop/scale'
require 'mobiusloop/scale_error'
require 'mobiusloop/scale_sample'

describe 'Outcome' do

  it 'should require a name and Scale as initialize params' do
    outcome = Outcome.new("test scale", ScaleSample.new)
    expect(outcome.name).to eql("test scale")
  end

  it 'should throw an exception if name is nil' do
    expect{Outcome.new(nil, ScaleSample)}.to raise_error(Exception)
  end

  it 'should throw an exception if second initialize param is not a Scale' do
    expect{Outcome.new("test scale", nil)}.to raise_error(Exception)
    expect{Outcome.new("test scale", Array.new)}.to raise_error(Exception)
  end

end

describe 'Outcome Measurements' do

  it 'should return Success on a valid measurement' do
    outcome = Outcome.new("test", ScaleSample.new)
    expect(outcome.measure).to include("Success")
    expect(outcome.measure).to_not include("Error")
  end

  it 'should return Error if a problem taking measurement' do
    outcome = Outcome.new("test", ScaleError.new)
    expect(outcome.measure).to include("Error")
    expect(outcome.measure).to_not include("Success")
  end
end

describe 'Outcome Number Format' do
  it 'should format positive numbers like 1000000 as 1,000,000' do
    outcome = Outcome.new("test", ScaleSample.new)
    expect(outcome.format_number(Measure.new(1000000))).to eql("1,000,000")
    expect(outcome.format_number(Measure.new(5000))).to eql("5,000")
    expect(outcome.format_number(Measure.new(100000))).to eql("100,000")
  end

  it 'should format decimals like 0.0 as 0.0' do
    outcome = Outcome.new("test", ScaleSample.new)
    expect(outcome.format_number(Measure.new(0.0))).to eql("0.0")
    expect(outcome.format_number(Measure.new(4.5))).to eql("4.5")
  end
end

# helper method to generate filename for testing
def create_expected_filename
  "#{Time.now.strftime(Outcome::FILENAME)}"
end
