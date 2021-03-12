module Kiba
  module Common
    module Sources
      class Enumerable
        attr_reader :enumerable

        def initialize(enumerable)
          @enumerable = enumerable
        end

        def unwrap_enumerable
          enumerable.respond_to?(:call) ? enumerable.call : enumerable
        end

        def each
          unwrap_enumerable.each { |row| yield row }
        end
      end
    end
  end
end
