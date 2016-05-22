require 'mobiusloop/scale'
require 'mobiusloop/measure'

class TotalArticlesScale < Scale

  def measure
    Measure.new(42000)
  end

end