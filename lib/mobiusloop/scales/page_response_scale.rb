require 'benchmark'
require 'mobiusloop/scale'

require "net/http"
require "uri"

# Records the response time of a web page
class PageResponseScale < Scale

  attr_accessor :location

  # returns a new Measure with response time of the :location
  def measure
    @location = "http://google.com" if @location == nil
    time = Benchmark.measure do
      response = Net::HTTP.get_response(URI.parse(@location))
    end
    Measure.new(time.real)
  end
end