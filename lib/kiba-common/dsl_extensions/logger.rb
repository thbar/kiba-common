require "logger"

module Kiba
  module Common
    module DSLExtensions
      # Logging facility for Kiba
      module Logger
        def logger=(logger_instance)
          @logger = logger_instance
        end

        def logger
          @logger ||= self.logger = ::Logger.new(STDOUT)
        end
      end
    end
  end
end
