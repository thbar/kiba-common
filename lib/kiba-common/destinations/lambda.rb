module Kiba
  module Common
    module Destinations
      class Lambda
        attr_reader :on_write, :on_close
        
        def initialize(on_init: nil, on_write: nil, on_close: nil)
          @on_write = on_write
          @on_close = on_close
          on_init&.call
        end

        def write(row)
          on_write&.call(row)
        end

        def close
          on_close&.call
        end
      end
    end
  end
end
