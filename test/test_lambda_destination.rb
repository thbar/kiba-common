require_relative "helper"
require "kiba"
require "kiba-common/destinations/lambda"

class TestLambdaDestination < Minitest::Test
  def test_lambda
    accumulator = []
    on_init_called = false
    on_close_called = false
    job = Kiba.parse do
      source Kiba::Common::Sources::Enumerable, ["one", "two"]
      destination Kiba::Common::Destinations::Lambda,
        on_init: -> { on_init_called = true },
        on_write: ->(r) { accumulator << r },
        on_close: -> { on_close_called = true }
    end
    Kiba.run(job)
    assert_equal ["one", "two"], accumulator
    assert_equal true, on_init_called
    assert_equal true, on_close_called
  end
end
