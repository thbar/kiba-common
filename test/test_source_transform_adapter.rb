require_relative 'helper'
require 'kiba-common/transforms/source_transform_adapter'

class TestSourceTransformAdapter < Minitest::Test
  include Kiba::Common::Sources
  include Kiba::DSLExtensions

  def test_instantiation
    rows = []
    job = Kiba.parse do
      extend Config
      config :kiba, runner: Kiba::StreamingRunner

      source Enumerable, [
        [ Enumerable, (1..10) ],
        [ Enumerable, (11..20) ]
      ]
      transform Kiba::Common::Transforms::SourceTransformAdapter
      destination TestArrayDestination, rows
    end
    Kiba.run(job)
    assert_equal (1..20).to_a, rows
  end
end