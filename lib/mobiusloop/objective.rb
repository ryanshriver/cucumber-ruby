require 'json'
require 'fileutils'

class Objective

  @@objectives = Array.new   # class array holds instances of objectives one per .goal file

  # needs to just be adding 1
  def self.add_current(name)
    objective = Objective.new(name)
    if @@objectives.include?(objective) == false
      @@objectives.push(objective)
    end
    self.get_current
  end

  def self.get_current
    @@objectives.last
  end

  def self.get_all
    @@objectives
  end


  attr_reader :name
  attr_reader :outcomes

  def initialize(name)
    @name = name
    @outcomes = []
  end


  def add_outcome(outcome)
    @outcomes.push(outcome)
  end


  # persist the results. May be overridden by subclasses
  def save
    filename = Time.now.strftime("measures-%Y-%m-%d-%H%M%S.json")
    dirname = "goals/measures"
    hash = { "objective" => @name}
    @outcomes.each {|o|
      hash.store("outcome", o.name)
      hash.store("scale", "#{o.scale.class.name}.rb")
      hash.store("baseline", o.baseline)
      hash.store("baseline date", o.baseline_date)
      hash.store("target", o.target)
      hash.store("target date", o.target_date)
      hash.store("measure", o.last_measure.value)
      hash.store("measure date", Time.now.strftime("%b %-d, %Y"))
    }

    if !File.exists? dirname
      FileUtils.mkdir_p dirname
    end

    File.open("#{dirname}/#{filename}","a") do |f|
      f.write(JSON.pretty_generate(hash))
      f.write("\n")
    end
  end


  def ==(other)
    other.class == self.class && other.name == self.name
  end


  def state
    self.instance_variables.map { |variable| self.instance_variable_get variable }
  end

end