class TestHashConfiguredObject
  def initialize(config)
    @config = config
  end
  
  def each
    yield(@config)
  end
end
