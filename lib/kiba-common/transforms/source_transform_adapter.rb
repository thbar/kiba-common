module Kiba
  module Common
    module Transforms
      class SourceTransformAdapter
        def process(args)
          klass = args.shift
          if args.last.is_a?(Hash) && RUBY_VERSION >= "2.7"
            kwargs = args.pop
            instance = klass.new(*args, **kwargs)
          else
            instance = klass.new(*args)
          end
          instance.each do |row|
            yield(row)
          end
          nil
        end
      end
    end
  end
end