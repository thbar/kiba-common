module Kiba
  module Common
    module Transforms
      class EnumerableExploder
        def process(row)
          row.each { |r| yield r }
          nil
        end
      end
    end
  end
end
