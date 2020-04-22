require_relative 'helper'
require 'kiba'
require 'kiba-common/destinations/destination_pre_processor'
require 'kiba-common/destinations/lambda'

class TestRowPreProcessorDestination < MiniTest::Test
  include Kiba::Common::Destinations
  include Kiba::Common::Sources
  
  focus
  def test_filter_and_modify
    output = []
    close_called = false
    job = Kiba.parse do
      source Enumerable, (1..10)
      destination DestinationPreProcessor,
        row_pre_processor: -> (r) { r % 2 == 0 ? 100 + r : nil },
        destination: [
          Lambda,
          on_write: -> (r) { output << r },
          on_close: -> { close_called = true }
        ]
    end
    Kiba.run(job)
    
    assert_equal [102, 104, 106, 108, 110], output
    assert_equal true, close_called
  end
end
