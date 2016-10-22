require 'yaml'

class ConfigFile

  # Loads YAML file at config_path and returns Hash of key/value pairs
  def self.load_template(config_file)
    if config_file == nil || File.exists?(config_file) == false
      raise SyntaxError, "config file: #{File.expand_path(config_file)} not found"
    end

    #puts "  config: #{File.expand_path(config_file)}".colorize(:blue)
    config_yaml = YAML.load_file(config_file)
    config = Hash.new
    for item in config_yaml
      config.store(item[0], item[1])
    end
    return config
  end

end