require 'rspec'
require 'mobiusloop/scale'

describe 'Scale' do

  it 'should throw exception if measure method is not overridden' do
    scale = Scale.new
    expect{scale.measure}.to raise_error(Exception)
  end


  it 'should return a new measure when record_measurement is called' do
    scale = ScaleSample.new
    measure1  = scale.measure
    expect(measure1).to_not eql(nil)
    expect(measure1.value).to eql(1)

    measure2 = scale.measure
    expect(measure1.value).to_not eql(measure2.value)
    expect(measure2.value).to eql(2)
  end

end