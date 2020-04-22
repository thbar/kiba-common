require 'csv'

module Kiba
  module Common
    module Destinations
      class CSV
        attr_reader :filename, :csv_options, :csv, :headers

        def initialize(filename:, csv_options: nil, headers: nil, row_pre_processor: nil)
          @filename = filename
          @csv_options = csv_options || {}
          @headers = headers
          @row_pre_processor = row_pre_processor
        end

        def write(row)
          @csv ||= ::CSV.open(filename, 'wb', csv_options)
          call_row_pre_processor(row).each do |row|
            @headers ||= row.keys
            @headers_written ||= (csv << headers ; true)
            csv << row.fetch_values(*@headers)
          end
        end

        def call_row_pre_processor(row)
          return [row] if @row_pre_processor.nil?
          [@row_pre_processor.call(row)].flatten.compact
        end

        def close
          csv&.close
        end
      end
    end
  end
end
