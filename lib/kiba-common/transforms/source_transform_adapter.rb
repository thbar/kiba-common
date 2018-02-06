class SourceTransformAdapter
  def process(args)
    args.shift.new(*args).each do |row|
      yield(row)
    end
    nil
  end
end