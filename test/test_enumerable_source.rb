require_relative 'helper'
require 'kiba'
require_relative 'support/test_array_destination'

class TestEnumerableSource < Minitest::Test
  def test_source
    test = self
    job = Kiba.parse do
      rows = []
      source Kiba::Common::Sources::Enumerable, (1..10)
      transform { |r| r * 2 }
      destination TestArrayDestination, rows
      post_process do
        test.assert_equal (2..20).step(2).to_a, rows
      end
    end
    Kiba.run(job)
  end
end