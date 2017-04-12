require_relative 'helper'
require 'kiba'
require 'kiba-common/dsl_extensions/show_me'
require_relative 'support/test_enumerable_source'

class TestShowMe < Minitest::Test
  def test_show_me
    job = Kiba.parse do
      extend Kiba::Common::DSLExtensions::ShowMe
      source TestEnumerableSource, ['row']
      show_me!
    end

    mock = MiniTest::Mock.new
    mock.expect(:call, nil, ['row'])
    Kernel.stub(:ap, mock) do
      Kiba.run(job)
    end
    mock.verify
  end
end
