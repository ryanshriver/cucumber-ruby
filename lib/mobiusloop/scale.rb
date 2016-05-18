# Superclass for all scales of measure
# Designed to be extended with the measure method implemented
# by the specific

class Scale

  attr_reader :measurements

  # creates internal array to store measurements
  # if sub-classes need their own initialize logic
  # call super first
  def initialize
    @measurements = Array.new
  end

  # performs measurement and adds to internal array
  def record_measurement()
    new_measure = measure
    add(new_measure)
  end

  # method to perform a measurement, should return an instance of Measure
  def measure()
    raise "Someone forgot to override Scale.measure with their unique logic"
  end

  # adds a new measure to end of array
  def add(measure)
    @measurements.push(measure)
  end

end