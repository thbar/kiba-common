require 'kiba-common/sources/limiter'

class TestLimiter < Minitest::Test
  def test_limiter
    output = []
    job = Kiba.parse do
      source Kiba::Common::Sources::Limiter, 2,
        Kiba::Common::Sources::Enumerable, (1..100)
      destination TestArrayDestination, output
    end
    Kiba.run(job)
    assert_equal [1, 2], output
  end
end