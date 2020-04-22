module Kiba
  module Common
    module Destinations
      class DestinationPreProcessor
        attr_reader :row_pre_processor, :destination

        def initialize(config)
          @row_pre_processor = config.fetch(:row_pre_processor)
          klass, *args = config.fetch(:destination)
          @destination = klass.new(*args)
        end
        
        def write(row)
          processed_row = row_pre_processor.call(row)
          destination.write(processed_row) unless processed_row.nil?
        end
        
        def close
          destination&.close
          @destination = nil
        end
      end
    end
  end
end
