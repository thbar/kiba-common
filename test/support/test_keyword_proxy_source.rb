class TestKeywordProxySource
  def initialize(mandatory:, optional: nil)
    @mandatory = mandatory
    @optional = optional
  end
  
  def each
    yield({
      mandatory: @mandatory,
      optional: @optional
    })
  end
end
