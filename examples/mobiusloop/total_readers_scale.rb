require 'mobiusloop/scale'
require 'mobiusloop/measure'

class TotalReadersScale < Scale

  def measure
    Measure.new(820000)
  end

end