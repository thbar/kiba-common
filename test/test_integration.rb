require_relative 'helper'
require 'kiba'
require_relative 'support/test_array_destination'
require 'kiba-common/transforms/source_transform_adapter'
require 'kiba-common/sources/csv'
require 'kiba-common/destinations/csv'

# a testbed to verify & showcase how you can chain multiple components
class TestIntegration < Minitest::Test
  def write_csv(filename, data)
    d = Kiba::Common::Destinations::CSV.new(filename: filename)
    data.each { |r| d.write(r) }
    d.close
  end

  def test_multiple_csv_inputs
    Dir.mktmpdir do |dir|
      write_csv File.join(dir, '001.csv'), [first_name: 'John']
      write_csv File.join(dir, '002.csv'), [first_name: 'Kate']

      rows = []
      job = Kiba.parse do
        # enable the new streaming-runner (for SourceTransformAdapter support)
        extend Kiba::DSLExtensions::Config
        config :kiba, runner: Kiba::StreamingRunner

        # create one row per input file
        source Kiba::Common::Sources::Enumerable, -> { Dir[File.join(dir, '*.csv')] }

        # out of that row, create configuration for a CSV source
        transform do |r|
          [
            Kiba::Common::Sources::CSV,
            filename: r,
            csv_options: { headers: true, header_converters: :symbol }
          ]
        end

        # instantiate & yield CSV rows for each configuration
        transform Kiba::Common::Transforms::SourceTransformAdapter

        destination TestArrayDestination, rows
      end
      Kiba.run(job)

      assert_equal([
        { first_name: 'John' },
        { first_name: 'Kate' }
      ], rows.map(&:to_h))
    end
  end

  def test_csv_source_and_destination
    Dir.mktmpdir do |dir|
      input_file = File.join(dir, '003.csv')
      output_file = File.join(dir, '004.csv')
      write_csv input_file, [first_name: 'John']

      job = Kiba.parse do
        source Kiba::Common::Sources::CSV,
          filename: input_file,
          csv_options: {
            headers: true
          }
        destination Kiba::Common::Destinations::CSV,
          filename: output_file
      end

      Kiba.run(job)

      run_etl = IO.read(output_file)

      assert_equal <<~CSV, run_etl
        first_name
        John
      CSV
    end
  end
end
