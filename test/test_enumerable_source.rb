require_relative "helper"
require "kiba"
require_relative "support/test_array_destination"

class TestEnumerableSource < Minitest::Test
  def assert_enumerable_source(input:, expected_output:)
    test = self
    job = Kiba.parse do
      rows = []
      source Kiba::Common::Sources::Enumerable, input
      transform { |r| r * 2 }
      destination TestArrayDestination, rows
      post_process do
        test.assert_equal expected_output, rows
      end
    end
    Kiba.run(job)
  end

  def test_source_as_enumerable
    assert_enumerable_source(input: (1..10), expected_output: (2..20).step(2).to_a)
  end

  def test_source_as_callable
    assert_enumerable_source(input: -> { (1..10) }, expected_output: (2..20).step(2).to_a)
  end
end
