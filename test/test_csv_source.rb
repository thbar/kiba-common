require_relative 'helper'
require 'kiba'
require 'kiba-common/sources/csv'
require_relative 'support/test_array_destination'

class TestCSVSource < MiniTest::Test
  TEST_FILENAME = 'input.csv'

  def setup
    CSV.open(TEST_FILENAME, 'wb') do |csv|
      csv << %w(first_name last_name)
      csv << %w(John Barry)
      csv << %w(Kate Bush)
    end
  end

  def teardown
    FileUtils.rm(TEST_FILENAME) if File.exist?(TEST_FILENAME)
  end

  def run_job(args)
    rows = []
    job = Kiba.parse do
      source Kiba::Common::Sources::CSV, **args
      destination TestArrayDestination, rows
    end
    Kiba.run(job)
    rows
  end

  def test_with_csv_options
    rows = run_job filename: TEST_FILENAME,
      csv_options: { headers: true, header_converters: :symbol }

    assert_equal [CSV::Row], rows.map(&:class).uniq
    assert_equal([
      {first_name: "John", last_name: "Barry" },
      {first_name: "Kate", last_name: "Bush"}
    ], rows.map(&:to_h))
  end

  def test_without_csv_options
    rows = run_job(filename: TEST_FILENAME)

    assert_equal [
      %w(first_name last_name),
      %w(John Barry),
      %w(Kate Bush)
    ], rows
  end
end
