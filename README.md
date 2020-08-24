Kiba Common is a companion gem to [Kiba](https://github.com/thbar/kiba) and [Kiba Pro](https://github.com/thbar/kiba/blob/master/Pro-Changes.md) in which I'll share commonly used helpers.

[![Build Status](https://travis-ci.org/thbar/kiba-common.svg?branch=master)](https://travis-ci.org/thbar/kiba-common) [![Gem Version](https://badge.fury.io/rb/kiba-common.svg)](https://badge.fury.io/rb/kiba-common)

## Usage

Add `kiba-common` to your `Gemfile`:

```ruby
gem 'kiba-common'
```

Then see below for each module usage & require clause.

## Supported Ruby versions

`kiba-common` currently supports Ruby 2.3+ and JRuby (with its default 1.9 syntax). See [test matrix](https://travis-ci.org/thbar/kiba-common).

## Available components

### Kiba::Common::Sources::Enumerable

A source enabling any enumerable (or rather any class implementing `each`) to generate rows for a data pipeline.

Usage:

```ruby
require 'kiba-common/sources/enumerable'

# will generate one row per number between 1 and 100
source Kiba::Common::Sources::Enumerable, (1..100)
```

You can pass a callable to make sure the evaluation will occur after your [pre-processors](https://github.com/thbar/kiba/wiki/Implementing-pre-and-post-processors) (which is considered a good thing), like this:

```ruby
# will evaluate the list of files at run time, after "pre_process" steps are called
source Kiba::Common::Sources::Enumerable, -> { Dir["input/*.json"] }
```

### Kiba::Common::Transforms::SourceTransformAdapter

Let's say you have a source (e.g. `CSVSource`), which you would like to instantiate for each input row (e.g. a list of filenames). 

Normally you'd have to bake file iteration right inside your source. 

But since Kiba v2 introduction of `StreamingRunner`, it is possible for transforms to yield an arbitrary (potentially infinite) amount of rows.

Leveraging that possibility, you can use a `SourceTransformAdapter` to dynamically instantiate the source for each of your input rows.

This allows you to mix-and-match components in a much more versatile & powerful way.

Requirements: Kiba v2 with `StreamingRunner` enabled.

Usage:

```ruby
source Kiba::Common::Sources::Enumerable, -> { Dir["input/*.csv"] }

transform do |r|
  # build up the args that you would normally pass to your source, e.g.
  # source MyCSV, filename: 'file.csv'
  # but instead, using the input as a parameter
  [MyCSVSource, filename: r]
end

# this will instantiate one source per input row, yielding rows
# that your source would normally yield
transform Kiba::Common::Transforms::SourceTransformAdapter
```

This can be used for a wide array of scenarios, including extracting data for N third-party accounts of a same system, with an array of API keys etc.

### Kiba::Common::Transforms::EnumerableExploder

A transform calling `each` on input rows (assuming they are e.g. arrays of sub-rows) and yielding one output row per enumerated element.

Requirements: [Kiba v2](https://github.com/thbar/kiba/releases/tag/v2.0.0) with `StreamingRunner` enabled.

Usage:

```ruby
require 'kiba-common/transforms/enumerable_exploder'

transform Kiba::Common::Transforms::EnumerableExploder
```

This can help if you are reading XML/JSON documents from a source and each input document contains multiple rows that you want to extract.

```ruby
source Kiba::Common::Sources::Enumerable, -> { Dir["input/*.xml"] }

transform { |r| IO.binread(r) }
transform { |r| Nokogiri::XML(r) }
# this will return an array of XML elements
transform { |r| r.search('/orders') }
# this will explode the array (one order per output row)
transform Kiba::Common::Transforms::EnumerableExploder
```

Similarly, if you have a CSV document as your input:

| po_number  | buyers |
| ------------- | ------------- |
| 00001  | John:Mary:Sally  |

and you want to reformat it to the following:

| po_number | buyer |
|-------------|---------|
| 00001 | John |
| 00001 | Mary |
| 00001 | Sally |

then you can explode them again with:

```ruby
source MyCSVSource, filename: "input.csv"

transform do |row|
  row.fetch(:buyers).split(':').map do |buyer|
    { 
      po_number: row.fetch(:po_number),
      buyer: buyer
    }
  end
end

transform Kiba::Common::Transforms::EnumerableExploder
```

### Kiba::Common::Sources::CSV

A CSV source for basic needs (in particular, it doesn't yield row metadata, which are useful in more advanced scenarios).

Use the `csv_options` keyword to control the input format like when using [Ruby CSV class](http://ruby-doc.org/stdlib-2.4.0/libdoc/csv/rdoc/CSV.html#method-c-new).

Usage:

```ruby
require 'kiba-common/sources/csv'

# by defaults, csv_options are empty
source Kiba::Common::Sources::CSV, filename: 'input.csv'

# you can provide your own csv_options
source Kiba::Common::Sources::CSV, filename: 'input.csv',
  csv_options: { headers: true, header_converters: :symbol }
```

Note that the emitted rows are instances of [`CSV::Row`](http://ruby-doc.org/stdlib-2.5.3/libdoc/csv/rdoc/CSV/Row.html), part `Array` and part `Hash`, which retain order of fields and allow duplicates (unlike a regular `Hash`).

If the rest of your pipeline expects `Hash` rows (like for instance `Kiba::Common::Destinations::CSV`), you'll want to transform the rows to `Hash` instances yourself using [`to_hash`](http://ruby-doc.org/stdlib-2.5.3/libdoc/csv/rdoc/CSV/Row.html#method-i-to_hash). This will "collapse the row into a simple Hash. Be warned that this discards field order and clobbers duplicate fields."

```ruby
transform { |r| r.to_hash }
```

#### Handling multiple input CSV files

You can process multiple files by chaining the various components available in Kiba Common (see `test/test_integration#test_multiple_csv_inputs` for an actual demo):

```ruby
# create one row per input filename
source Kiba::Common::Sources::Enumerable, -> { Dir[File.join(dir, '*.csv')] }

# out of that row, create configuration for a CSV source
transform do |r|
  [
    Kiba::Common::Sources::CSV,
    filename: r,
    csv_options: { headers: true, header_converters: :symbol }
  ]
end

# instantiate & yield CSV rows for each configuration
transform Kiba::Common::Transforms::SourceTransformAdapter
```

Alternatively, you can wrap this source in your own source like this:

```ruby
class MultipleCSVSource
  def initialize(file_pattern:, csv_options:)

  def each
    Dir[file_pattern].each do |filename|
      Kiba::Common::Sources::CSV.new(filename, csv_options).each do |row|
        yield row
      end
    end
  end
end
```

### Kiba::Common::Destinations::CSV

A way to dump `Hash` rows as CSV.

All rows are expected to have the exact same set of keys as the first row.

The headers will be the first row keys unless you pass an array of keys via `headers`.

All keys are mandatory (although they can have a `nil` value).

Use the `csv_options` keyword to control the output format like when using [Ruby CSV class](http://ruby-doc.org/stdlib-2.4.0/libdoc/csv/rdoc/CSV.html#method-c-new).

Usage:

```ruby
require 'kiba-common/destinations/csv'

# by default, the headers will be picked from the first row:
destination Kiba::Common::Destinations::CSV,
  filename: 'output.csv'

# if you need a different separator:
destination Kiba::Common::Destinations::CSV,
  filename: 'output.csv',
  csv_options: { col_sep: ';' }
  
# to enforce a specific set of headers:
destination Kiba::Common::Destinations::CSV,
  filename: 'output.csv',
  headers: [:field, :other_field]
```

### Kiba::Common::Destinations::Lambda

At times, it can be convenient to use a block form for a destination (pretty much like Kiba's built-in "block transform"), especially for one-off scripts.

The Lambda destination is there for that purpose.

Example use:

```ruby
require 'kiba-common/destinations/lambda'

destination Kiba::Common::Destinations::Lambda,
  # called at destination instantiation time (once)
  on_init: -> { ... },
  # called for each row
  on_write: -> (row) { ... },
  # called after all the rows have been written
  on_close: -> { ... }
```

Each "callback" (e.g. `on_init`) is optional.

The callback code can refer to scope variables or instance variables you may have declared above.

### Kiba::Common::DSLExtensions::Logger

A simple logging facility.

Usage:

```ruby
require 'kiba-common/dsl_extensions/logger'
extend Kiba::Common::DSLExtensions::Logger

pre_process do
  logger.info "pre_process is running!"
end
```

By default the logger will output to `STDOUT`.

You can customize that behaviour by setting the logger:

```ruby
require 'kiba-common/dsl_extensions/logger'
extend Kiba::Common::DSLExtensions::Logger

logger = Logger.new(xxx)
```

### Kiba::Common::DSLExtensions::ShowMe

A way to color-dump rows on the screen, useful during development when you are inspecting the data (requires either the `amazing_print` or the `awesome_print` gem).

Usage:

```ruby
require 'kiba-common/dsl_extensions/show_me'
extend Kiba::Common::DSLExtensions::ShowMe

source MySource
transform MyTransform
show_me! # will color-print the row at this step of the pipeline
```

You can also pre-process the data to only show specific parts of the row:

```ruby
require 'active_support/core_ext/hash/except'

show_me! { |r| r.except(:some_noisy_field) }
```

## Contributing & Legal

See [LICENSE](LICENSE) for license.

(agreement below borrowed from Sidekiq Legal)

By submitting a Pull Request, you disavow any rights or claims to any changes submitted to the Kiba Common project and assign the copyright of those changes to LoGeek SARL.

If you cannot or do not want to reassign those rights (your employment contract for your employer may not allow this), you should not submit a PR. Open an issue and someone else can do the work.

This is a legal way of saying "If you submit a PR to us, that code becomes ours". 99.9% of the time that's what you intend anyways; we hope it doesn't scare you away from contributing.
