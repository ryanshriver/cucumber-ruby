require 'rspec'
require 'mobiusloop/scale'

describe 'Scale' do

  it 'should initialize with a new measurements array' do
    scale = Scale.new
    expect(scale.measurements).to_not be_nil
    expect(scale.measurements.size).to eql(0)
  end

  it 'should throw exception if measure method is not overridden' do
    scale = Scale.new
    expect{scale.measure}.to raise_error(Exception)
  end

  it 'should add new measurements when recorded' do
    scale = ScaleSample.new
    scale.record_measurement
    scale.record_measurement
    expect(scale.measurements.size).to eql(2)
    expect(scale.measurements.last.value).to eql(2)
    expect(scale.measurements.first.value).to eql(1)
  end

  it 'should return nil if no measurements' do
    scale = Scale.new
    expect(scale.measurements.last).to be_nil
  end


  it 'should add a new measurement when measure is called' do
    scale = ScaleSample.new
    scale.record_measurement
    expect(scale.measurements.size).to eql(1)
    expect(scale.measurements.last.value).to eql(1)
    scale.record_measurement
    expect(scale.measurements.size).to eql(2)
    expect(scale.measurements.last.value).to eql(2)
  end


end