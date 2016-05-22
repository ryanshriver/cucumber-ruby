require 'rspec'
require 'mobiusloop/scales/page_response_scale'

describe 'Record Web Page Times' do

  it 'should ping google quickly and record a new measure' do
    scale = PageResponseScale.new
    expect(scale.measurements.size).to eql(0)
    scale.location = "http://google.com"

    scale.record_measurement

    expect(scale.measurements.size).to eql(1)
    expect(scale.measurements.last.value).to be > 0
  end
end