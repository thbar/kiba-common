require 'csv'

module Kiba
  module Common
    module Sources
      class CSV
        attr_reader :filename, :csv_options

        def initialize(filename, csv_options: {})
          @filename = filename
          @csv_options = csv_options
        end

        def each
          ::CSV.foreach(filename, csv_options) do |row|
            yield row
          end
        end
      end
    end
  end
end
