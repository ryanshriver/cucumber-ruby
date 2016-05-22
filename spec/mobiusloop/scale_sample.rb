require 'mobiusloop/scale'

# sample scale of measure for testing
class ScaleSample < Scale

  attr_accessor :counter

  def initialize
    super
    @counter = 0
  end

  # each time you call measure, it generates a new measurement
  # with an incremental number (e.g. 1, 2, 3, etc.)
  def measure
    Measure.new(@counter+=1)
  end
end