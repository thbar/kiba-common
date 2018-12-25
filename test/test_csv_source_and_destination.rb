require_relative 'helper'
require 'kiba'
require 'kiba-common/sources/csv'
require 'kiba-common/destinations/csv'

class TestCSVSourceAndDestination < Minitest::Test
  INPUT_FILENAME = 'input.csv'
  OUTPUT_FILENAME = 'output.csv'

  def setup
    CSV.open(INPUT_FILENAME, 'wb') do |csv|
      csv << %w(name age)
      csv << %w(world 999)
    end
  end

  def teardown
    File.delete(INPUT_FILENAME) if File.exist?(INPUT_FILENAME)
    File.delete(OUTPUT_FILENAME) if File.exist?(OUTPUT_FILENAME)
  end

  def run_etl
    job = Kiba.parse do
      source Kiba::Common::Sources::CSV,
        filename: INPUT_FILENAME,
        csv_options: {
          headers: true
        }
      destination Kiba::Common::Destinations::CSV,
        filename: OUTPUT_FILENAME
    end

    Kiba.run(job)

    IO.read(OUTPUT_FILENAME)
  end

  def test_csv_source_and_destination
    assert_equal <<~CSV, run_etl
      name,age
      world,999
    CSV
  end
end
