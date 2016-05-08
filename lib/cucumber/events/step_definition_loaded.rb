module Cucumber
  module Events

    # Event fired after each step definition has been loaded
    class StepDefinitionLoaded

      # The step definition that was just loaded.
      #
      # @return [Cucumber::Core::Test::Case]
      attr_reader :step_definition

      # @private
      def initialize(step_definition)
        @step_definition = step_definition
      end

    end

  end
end
