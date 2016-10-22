# Represents a specific outcome or key result to be achieved

require 'json'
require 'colorize'

class Outcome

  FILENAME = 'measures'

  attr_reader   :name
  attr_accessor :baseline
  attr_accessor :baseline_date
  attr_accessor :target
  attr_accessor :target_date
  attr_reader   :scale
  attr_accessor :persist
  attr_reader   :last_measure

  # register a name (String) and scale (Scale) of measurement at creation time
  def initialize(name, scale, persist = false)
    raise "name must not be nil" if name == nil
    raise "scale must be of type Scale" unless scale.is_a? Scale
    @name = name
    @scale = scale
    @persist = persist
  end

  # perform the measurement using the provide scale
  # delegate the details to any class extending Scale
  # TODO: Change measurement to benchmark
  def measure
    begin
      start_time = Time.now
      @last_measure = @scale.measure
      elapsed_time = (Time.now - start_time)
      return "Success! Measured " + format_number(@last_measure) + " " + @name + " in #{elapsed_time.round(1)} seconds!"
    rescue Exception => e
      return "Error! Measurement failed with message: " + e.message
    end
  end

  # used to report progress towards goals
  def report
    report = ""
    report << report_progress
    report << report_remaining
    report
  end

  # format number for display (1000000 => 1,000,000)
  # unless number starts with 0 or .
  def format_number(measure)
    if measure != nil || measure.value != nil
      whole, decimal = measure.value.to_s.split(".")
      whole_with_commas = whole.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
      [whole_with_commas, decimal].compact.join(".")
    end
  end


  private

  # report the status. Very simplistic now, need to validate if there is need
  # for this or we should just drop and let others determine status
  def status
    status = percent_progress - percent_schedule
    # this value of 10 is temporary. TODO: need to make this more flexible and explainable
    if status.abs < 10
      "Hooray! You are on track!\n"
    else
      "Sorry, you are not on track\n"
    end
  end

  # report percentage progress towards the target
  def report_progress
    config = ConfigFile.load_template("#{Dir.pwd}/goals/support/config.yml")

    progress = percent_progress.round(0)
    schedule = percent_schedule.round(0)
    delta = (progress - schedule).abs
    days = progress_days
    result = ""

    if config.has_key?('progress') && config['progress'].has_key?('good') && config['progress'].has_key?('bad')
      good = config['progress']['good'].to_i
      bad = config['progress']['bad'].to_i

      if (delta <= good)
        result = "#{progress}% progress to target using #{schedule}% of the time (#{days} days)\n".colorize(:green)
      elsif (delta >= bad)
        result =  "#{progress}% progress to target using #{schedule}% of the time (#{days} days)\n".colorize(:red)
      else
        result =  "#{progress}% progress to target using #{schedule}% of the time (#{days} days)\n".colorize(:yellow)
      end
    end
    result
  end

  def report_remaining
    config = ConfigFile.load_template("#{Dir.pwd}/goals/support/config.yml")

    days_remaining = remaining_days
    remaining = percent_remaining.round(0)

    progress = percent_progress.round(0)
    schedule = percent_schedule.round(0)
    delta = (progress - schedule).abs
    result = ""

    if config.has_key?('progress') && config['progress'].has_key?('good') && config['progress'].has_key?('bad')
      good = config['progress']['good'].to_i
      bad = config['progress']['bad'].to_i

      if (delta <= good)
        result = "#{remaining}% remaining to target in #{days_remaining} days\n".colorize(:green)
      elsif (delta >= bad)
        result =  "#{remaining}% remaining to target in #{days_remaining} days\n".colorize(:red)
      else
        result =  "#{remaining}% remaining to target in #{days_remaining} days\n".colorize(:yellow)
      end
    end
    result
  end

  # percentage progress towards target as of now
  def percent_progress
    ((@last_measure.value.to_i - @baseline.to_i).to_f /
        (@target.to_i - @baseline.to_i).to_f * 100)
  end

  # percentage schedule used as of o now
  def percent_schedule
    ((DateTime.now - DateTime.parse(@baseline_date)).to_i /
        (DateTime.parse(@target_date) - DateTime.parse(@baseline_date)).to_f * 100)
  end

  # percent remaining
  def percent_remaining
    100 - percent_progress
  end

  # days from baseline date until now
  def progress_days
    (DateTime.now - DateTime.parse(baseline_date)).to_i
  end

  # days remaining until target date
  def remaining_days
    (DateTime.parse(target_date) - DateTime.now).to_i
  end

end