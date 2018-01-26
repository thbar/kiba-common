require_relative 'helper'
require 'kiba'
require_relative 'support/test_array_destination'
require 'kiba-common/transforms/enumerable_exploder'
require 'kiba/dsl_extensions/config'

class TestEnumerableExploderTransform < Minitest::Test
  def test_exploder
    output = []
    input = [[1,2],[3,4,5]]

    job = Kiba.parse do
      extend Kiba::DSLExtensions::Config
      config :kiba, runner: Kiba::StreamingRunner

      source Kiba::Common::Sources::Enumerable, input
      transform Kiba::Common::Transforms::EnumerableExploder
      destination TestArrayDestination, output
    end
    Kiba.run(job)
    
    assert_equal input.flatten, output
  end
end