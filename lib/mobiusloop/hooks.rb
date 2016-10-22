require 'mobiusloop/objective'
require 'mobiusloop/config/config_file'

Before do |scenario|
  Objective.add_current(scenario.feature.name)
  #puts "scenario name #{scenario.name}"
end

After do |scenario|
  config_dir =  File.dirname(File.absolute_path(__FILE__))
  config_filepath = "#{config_dir}/config.yml"
  config = ConfigFile.load_template(config_filepath)

  if config.has_key?('measures') && config['measures'].has_key?('save')
    persist = config['measures']['save']
    if persist
      objective = Objective.get_current
      objective.save
    end
  end

end