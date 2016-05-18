# Records a measurement of a specific value at a specific time
# Once created, measures are immutable

class Measure

  attr_reader :value
  attr_reader :time

  # constructor that records a value and a time that defaults to Time.now unless overridden)
  # constructor that records value at a defined time (instance of Time).
  # Only number values allowed.
  def initialize(value, time = Time.now)
    raise "Error! Only numbers are allowed for Measure values" unless value.is_a? Numeric
    raise "Error! Only Time is allowed for Measure time" unless time.is_a? Time
    @value = value
    @time = time
  end

end