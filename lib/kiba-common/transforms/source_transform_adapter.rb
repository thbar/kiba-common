module Kiba
  module Common
    module Transforms
      class SourceTransformAdapter
        def process(args)
          args.shift.new(*args).each do |row|
            yield(row)
          end
          nil
        end
      end
    end
  end
end