module Kiba
  module Common
    module Sources
      class Enumerable
        def initialize(enumerable)
          @enumerable = enumerable
        end

        def each
          @enumerable.each do |row|
            yield row
          end
        end
      end
    end
  end
end
