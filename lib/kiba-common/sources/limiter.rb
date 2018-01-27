module Kiba
  module Common
    module Sources
      class Limiter
        attr_reader :limit, :source_class, :source_args
        
        def initialize(limit, source_class, *source_args)
          @limit = limit
          @source_class = source_class
          @source_args = source_args
        end
        
        def each
          index = 0
          source_class.new(*source_args).each do |row|
            index += 1
            break if limit && (index > limit)
            yield row
          end
        end
      end
    end
  end
end