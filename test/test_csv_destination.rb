require_relative 'helper'
require 'kiba'
require 'kiba-common/destinations/csv'

class TestCSVDestination < Minitest::Test
  TEST_FILENAME = 'output.csv'
    
  def teardown
    File.delete(TEST_FILENAME) if File.exist?(TEST_FILENAME)
  end

  def run_etl(csv_options: nil, headers: nil)
    job = Kiba.parse do
      source TestEnumerableSource, [
        {name: "world", age: 999}
      ]
      destination Kiba::Common::Destinations::CSV,
        filename: TEST_FILENAME,
        csv_options: csv_options,
        headers: headers
    end

    Kiba.run(job)
    
    IO.read(TEST_FILENAME)
  end
  
  def test_classic
    assert_equal <<~CSV, run_etl
      name,age
      world,999
    CSV
  end
  
  def test_csv_options
    assert_equal <<~CSV, run_etl(csv_options: {col_sep: ';'})
      name;age
      world;999
    CSV
  end
  
  def test_headers_provided
    assert_equal <<~CSV, run_etl(headers: [:age])
      age
      999
    CSV
  end
end
