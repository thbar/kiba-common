require_relative 'helper'
require 'kiba'
require 'kiba-common/destinations/destination_pre_processor'
require 'kiba-common/destinations/lambda'

class TestRowPreProcessorDestination < MiniTest::Test
  include Kiba::Common::Destinations
  include Kiba::Common::Sources
  
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

  def test_do_not_raise_if_destination_lacks_a_close_method
    output = []
    instance = Lambda.new(on_write: -> (r) { output << r })
    instance.instance_eval('undef :close')
    Lambda.stub(:new, instance) do
      Kiba.run(Kiba.parse do
        source Enumerable, (1..10)
        destination DestinationPreProcessor,
          row_pre_processor: -> (r) { r },
          destination: [ Lambda ]
      end)
      assert_equal (1..10).to_a, output
    end
  end
end
