require_relative 'helper'
require 'kiba'
require 'kiba-common/destinations/csv'

class TestCSVDestination < Minitest::Test
  TEST_FILENAME = 'output.csv'

  def teardown
    File.delete(TEST_FILENAME) if File.exist?(TEST_FILENAME)
  end

  def run_etl(csv_options: nil, headers: nil, row_pre_processor: nil)
    job = Kiba.parse do
      source Kiba::Common::Sources::Enumerable, [
        { name: "world", age: 999 },
        { name: "mars", age: 555 }
      ]
      destination Kiba::Common::Destinations::CSV,
        filename: TEST_FILENAME,
        csv_options: csv_options,
        headers: headers,
        row_pre_processor: row_pre_processor
    end

    Kiba.run(job)

    IO.read(TEST_FILENAME)
  end

  def test_classic
    assert_equal <<~CSV, run_etl
      name,age
      world,999
      mars,555
    CSV
  end

  def test_csv_options
    assert_equal <<~CSV, run_etl(csv_options: {col_sep: ';'})
      name;age
      world;999
      mars;555
    CSV
  end

  def test_headers_provided
    assert_equal <<~CSV, run_etl(headers: [:age])
      age
      999
      555
    CSV
  end

  def test_modification_row_pre_processor
    row_pre_processor = -> (row) {
      row.reduce({}) do |new_row, (key, value)|
        new_row.merge(key.to_s.upcase.to_sym => value)
      end
    }

    assert_equal <<~CSV, run_etl(row_pre_processor: row_pre_processor)
      NAME,AGE
      world,999
      mars,555
    CSV
  end

  def test_filter_row_pre_processor
    row_pre_processor = -> (row) {
      row[:age] < 600 ? row : nil
    }

    assert_equal <<~CSV, run_etl(row_pre_processor: row_pre_processor)
      name,age
      mars,555
    CSV
  end
end
