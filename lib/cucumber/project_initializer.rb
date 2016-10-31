module Cucumber

  # Generates generic file structure for a cucumber project
  class ProjectInitializer
    def run
      puts "file expand path = #{File.expand_path(__FILE__)}"
      @version = File.read(File.expand_path("../../../lib/mobiusloop/version", __FILE__))
      # normal cucumber init, replacing /features for /goals
      create_directory('goals')
      create_directory('goals/step_definitions')
      create_directory('goals/support')
      create_file('goals/support/env.rb')

      # extra mobiusloop initiialization
      copy_step_defs('mobius_steps.rb', 'goals/step_definitions')
      copy_step_defs('hooks.rb', 'goals/support')
      copy_step_defs('config/config.yml', 'goals/support')
      copy_step_defs('scales/page_response_scale.rb', 'goals/step_definitions') # example scale to measure response time
      copy_gherkin_languages('gherkin-languages.json')    # copy modified gherkin-languages.json file to gherkin gem(s)
      copy_example_file('total_articles_scale.rb', 'goals/step_definitions')
      copy_example_file('total_readers_scale.rb', 'goals/step_definitions')
      copy_example_file('increase_readers.goal', 'goals')
    end

    private

    def copy_step_defs(spec_file, target)
      gem_dir = `gem environment gemdir`
      steps_file = gem_dir.gsub("\n","") + "/gems/mobiusloop-#{@version}/lib/mobiusloop/" + spec_file
      report_copying(spec_file, target)
      copy_file(steps_file, target)
    end

    # note: this is penned to v3.2.0 of gherkin because 4.0.0 was causing issues
    # this is not very elegant, but works for now
    def copy_gherkin_languages(gherkin_file)
      gem_dir = `gem environment gemdir`
      source_gherkin = gem_dir.gsub("\n","") + "/gems/mobiusloop-#{@version}/" + gherkin_file
      target_gherkin = gem_dir.gsub("\n","") + "/gems/gherkin-3.2.0/lib/gherkin/"
      report_copying(gherkin_file, target_gherkin)
      copy_file(source_gherkin, target_gherkin)
    end

    def copy_example_file(file, target)
      gem_dir = `gem environment gemdir`
      steps_file = gem_dir.gsub("\n","") + "/gems/mobiusloop-#{@version}/examples/mobiusloop/" + file
      report_copying(file, target)
      copy_file(steps_file, target)
    end

    # TODO: Fix this to work with Windows. FileUtils does not parse ? in file path like Unix
    def copy_file(source, target)
      `cp -rf #{source} #{target}`
    end

    def create_directory(dir_name)
      create_directory_or_file dir_name, true
    end

    def create_file(file_name)
      create_directory_or_file file_name, false
    end

    def create_directory_or_file(file_name, directory)
      file_type = if directory
                    :mkdir_p
                  else
                    :touch
                  end

      report_exists(file_name) || return if File.exists?(file_name)
      report_creating(file_name)
      FileUtils.send file_type, file_name
    end

    def report_exists(file)
      puts "   exist   #{file}"
    end

    def report_creating(file)
      puts "  create   #{file}"
    end

    def report_copying(source, target)
      puts "  copy     #{source} => #{target}"
    end
  end
end