require_relative 'helper'
require 'kiba'
require 'kiba-common/destinations/csv'

class TestCSVDestination < Minitest::Test
  TEST_FILENAME = 'output.csv'
    
  def teardown
    File.delete(TEST_FILENAME)
  end

  def test_write_with_options
    job = Kiba.parse do
      source TestEnumerableSource, [
        {name: "world", age: 999}
      ]
      destination Kiba::Common::Destinations::CSV,
        filename: TEST_FILENAME,
        csv_options: { col_sep: ';' }
    end

    Kiba.run(job)
    
    assert_equal IO.read(TEST_FILENAME), <<~CSV
      name;age
      world;999
    CSV
  end
end
