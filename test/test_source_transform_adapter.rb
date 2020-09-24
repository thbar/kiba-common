require_relative 'helper'
require_relative 'support/test_keyword_proxy_source'
require_relative 'support/test_hash_configured_object'

# NOTE: the SourceTransformAdapter has been removed,
# but I'm keeping these tests, patched to instead use
# Enumerator, as a way to verify that the alternative
# I provided in the change log still works.
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

      transform do |klass, args|
        Enumerator.new do |y|
          klass.new(args).each do |r|
            y << r
          end
        end
      end
      transform Kiba::Common::Transforms::EnumerableExploder

      destination TestArrayDestination, rows
    end
    Kiba.run(job)
    assert_equal (1..20).to_a, rows
  end
  
  def test_instantiation_keyword_arguments
    rows = []
    job = Kiba.parse do
      source Enumerable, [
        # Test against a class that expects explicit keyword arguments
        [ TestKeywordProxySource, {mandatory: "some value"} ]
      ]

      transform do |klass, args|
        Enumerator.new do |y|
          klass.new(**args).each do |r|
            y << r
          end
        end
      end
      transform Kiba::Common::Transforms::EnumerableExploder

      destination TestArrayDestination, rows
    end
    Kiba.run(job)
    assert_equal([
      {mandatory: "some value", optional: nil}
    ], rows)
  end
  
  def test_hash_configured_object
    rows = []
    job = Kiba.parse do
      source Enumerable, [
        # Test against a class that takes a single Hash argument
        [ TestHashConfiguredObject, {mandatory: "some value"} ]
      ]

      transform do |klass, args|
        Enumerator.new do |y|
          klass.new(**args).each do |r|
            y << r
          end
        end
      end
      transform Kiba::Common::Transforms::EnumerableExploder

      destination TestArrayDestination, rows
    end
    Kiba.run(job)
    assert_equal([
      {mandatory: "some value"}
    ], rows)
  end
end
