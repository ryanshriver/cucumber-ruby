# Superclass for all scales of measure
# Designed to be extended with the measure method implemented
# by the specific


class Scale

  # creates internal array to store measurements
  # by default, persisting measures is turned off
  # if sub-classes need their own initialize logic call super first
  def initialize
  end

  # method to perform a measurement, should return an instance of Measure
  def measure()
    raise "Someone forgot to override Scale.measure with their unique logic"
  end

end