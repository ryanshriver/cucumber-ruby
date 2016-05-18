# Represents a specific outcome or key result to be achieved

class Outcome

  attr_reader   :name
  attr_accessor :baseline
  attr_accessor :baseline_date
  attr_accessor :target
  attr_accessor :target_date
  attr_reader   :scale

  # register a name (String) and scale (Scale) of measurement at creation time
  def initialize(name, scale)
    raise "name must not be nil" if name == nil
    raise "scale must be of type Scale" unless scale.is_a? Scale
    @name = name
    @scale = scale
  end

  # perform the measurement using the provide scale
  # delegate the details to any class extending Scale
  def measure
    begin
      start_time = Time.now
      @scale.record_measurement
      elapsed_time = (Time.now - start_time)
      return "Success! found " + format_number(@scale.measurements.last) + " " + @name + " in #{elapsed_time.round(1)} seconds!"
    rescue Exception => e
      return "Error! Measurement failed with message: " + e.message
    end
  end

  # used to report progress towards goals
  def report
    report = ""
    report << status
    report << report_progress
    report << report_remaining
    report
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
    "#{percent_progress.round(0)}% progress to target using #{percent_schedule.round(0)}% of the time (" + progress_days.to_s + " days)\n"
  end

  # report remaining progress towards the target
  def report_remaining
    "#{percent_remaining.round(0)}% remaining to target in #{remaining_days} days\n"
  end

  # percentage progress towards target as of now
  def percent_progress
    ((@scale.measurements.last.value.to_i - @baseline.to_i).to_f /
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

  # format number for display (1000000 => 1,000,000)
  def format_number(measure)
    measure.value.to_s.gsub(/(\d{3})(?=\d)/, '\\1,') unless measure == nil
  end

end