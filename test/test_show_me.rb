require_relative 'helper'
require 'kiba'
require 'amazing_print'
require 'kiba-common/dsl_extensions/show_me'

class TestShowMe < Minitest::Test
  include AssertCalled

  def test_show_me
    job = Kiba.parse do
      extend Kiba::Common::DSLExtensions::ShowMe
      source Kiba::Common::Sources::Enumerable, ['row']
      show_me!
    end
    
    assert_called(Kernel, :ap, ['row']) do
      Kiba.run(job)
    end
  end
  
  def test_show_me_pre_process
    output = []
    job = Kiba.parse do
      extend Kiba::Common::DSLExtensions::ShowMe
      source Kiba::Common::Sources::Enumerable, [{this: "OK", not_this: "KO"}]
      show_me! { |r| r.fetch(:this) }
      destination TestArrayDestination, output
    end

    assert_called(Kernel, :ap, ['OK']) do
      Kiba.run(job)
    end
    
    assert_equal [{this: "OK", not_this: "KO"}], output
  end
end
