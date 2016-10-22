require 'rspec'
require 'mobiusloop/scales/page_response_scale'

describe 'Record Web Page Times' do

  it 'should ping google quickly and record a new measure' do
    scale = PageResponseScale.new
    scale.location = "http://google.com"

    measure = nil
    measure = scale.measure

    expect(measure).to_not eql(nil)
    expect(measure.value).to be > 0
  end
end