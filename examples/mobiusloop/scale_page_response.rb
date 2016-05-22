require 'benchmark'
require 'scale'

require "net/http"
require "uri"

# Records the response time of a web page
class ScalePageResponse < Scale

  attr_accessor :location

  # returns a new Measure with response time of the :location
  def measure
    raise "Forgot to set the location" if @location == nil
    time = Benchmark.measure do
      response = Net::HTTP.get_response(URI.parse(@location))
    end
    Measure.new(time.real)
  end
end