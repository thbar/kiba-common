require 'awesome_print'

module Kiba
  module Common
    module DSLExtensions
      # Color print your row.
      module ShowMe
        def show_me!
          transform do |row|
            # NOTE: invoking Kernel.ap for testing since
            # ap itself is harder to mock (Kiba Context)
            Kernel.ap(row)
            row
          end
        end
      end
    end
  end
end
