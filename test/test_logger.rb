require_relative 'helper'
require 'kiba'
require 'kiba-common/dsl_extensions/logger'

class TestLogger < Minitest::Test
  def test_default_logger
    actual_logger = nil
    Kiba.parse do
      extend Kiba::Common::DSLExtensions::Logger
      actual_logger = logger
    end
    assert actual_logger.is_a?(Logger)
  end

  def test_set_logger
    buffer = StringIO.new

    job = Kiba.parse do
      extend Kiba::Common::DSLExtensions::Logger
      logger = Logger.new(buffer)

      pre_process do
        logger.info 'Logging from pre_process'
      end
    end
    Kiba.run(job)

    assert_includes buffer.string, 'Logging from pre_process'
  end
end
