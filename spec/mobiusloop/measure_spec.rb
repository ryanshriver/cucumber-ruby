require 'rspec'
require 'mobiusloop/measure'

describe 'Measure' do

  it 'should allow numeric values' do
    expect(Measure.new(4).value).to eq(4)
    expect(Measure.new(10.1234).value).to eq(10.1234)
    expect(Measure.new(-100).value).to eq(-100)
  end

  it 'raise exceptions for non-numeric values' do
    expect {Measure.new("silly non numeric")}.to raise_error(Exception)
  end


end