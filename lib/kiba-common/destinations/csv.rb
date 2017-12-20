require 'csv'

module Kiba
  module Common
    module Destinations
      class CSV
        attr_reader :filename, :csv_options
        
        def initialize(filename:, csv_options: nil)
          @filename = filename
          @csv_options = csv_options
        end
        
        def write(row)
          @csv ||= ::CSV.open(filename, 'wb', csv_options)
          @headers ||= begin
            @csv << (headers = row.keys)
            headers
          end
          @csv << row.fetch_values(*headers)
        end
        
        def close
          @csv&.close
        end
      end
    end
  end
end