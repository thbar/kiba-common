module AssertCalled
  def assert_called(klass, method, args, return_value = nil)
    mock = Minitest::Mock.new
    mock.expect(:call, return_value, args)
    klass.stub(method, mock) do
      yield
    end
    mock.verify
  end
end
