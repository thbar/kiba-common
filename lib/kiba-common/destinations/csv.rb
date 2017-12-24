require 'csv'

module Kiba
  module Common
    module Destinations
      class CSV
        attr_reader :filename, :csv_options, :csv, :headers
        
        def initialize(filename:, csv_options: nil, headers: nil)
          @filename = filename
          @csv_options = csv_options || {}
          @headers = headers
        end
        
        def write(row)
          @csv ||= ::CSV.open(filename, 'wb', csv_options)
          @headers ||= row.keys
          @headers_written ||= (csv << headers ; true)
          csv << row.fetch_values(*@headers)
        end
        
        def close
          csv&.close
        end
      end
    end
  end
end