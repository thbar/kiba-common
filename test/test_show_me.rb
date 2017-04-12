require_relative 'helper'
require 'kiba'
require 'kiba-common/dsl_extensions/show_me'

class TestShowMe < Minitest::Test
  include AssertCalled

  def test_show_me
    job = Kiba.parse do
      extend Kiba::Common::DSLExtensions::ShowMe
      source TestEnumerableSource, ['row']
      show_me!
    end
    
    assert_called(Kernel, :ap, ['row']) do
      Kiba.run(job)
    end
  end
end
