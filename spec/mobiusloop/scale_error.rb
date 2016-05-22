require 'mobiusloop/scale'

# sample scale of measure for testing
class ScaleError < Scale

  attr_accessor :counter

  def initialize
    super
    @counter = 0
  end

  # simulate something bad happening during measurement that raises and error
  def measure
    raise "something broke during measurement"
  end
end