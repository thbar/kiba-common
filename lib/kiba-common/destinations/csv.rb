require 'csv'

module Kiba
  module Common
    module Destinations
      class CSV
        attr_reader :filename, :csv_options
        
        def initialize(filename:, csv_options: {headers: true})
          @filename = filename
          @csv_options = csv_options
          unless @csv_options[:headers] == true
            fail ":headers CSV option must be set to true for now"
          end
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