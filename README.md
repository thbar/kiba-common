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

### Kiba::Common::Destinations::CSV

A way to dump `Hash` rows as CSV, using the first row's keys as headers.

All rows are expected to have the exact same set of keys as the first row.

Use the `csv_options` keyword to control the output format like you would do when using [Ruby CSV class](http://ruby-doc.org/stdlib-2.4.0/libdoc/csv/rdoc/CSV.html#method-c-new).

Usage:

```ruby
require 'kiba-common/destinations/csv'

destination Kiba::Common::Destinations::CSV,
  filename: 'output.csv',
  csv_options: { headers: true } # this is the default
  
# if you need a different separator, use:
destination Kiba::Common::Destinations::CSV,
  filename: 'output.csv',
  csv_options: { col_sep: ';', headers: true }
```

If you do not want to output some fields, you are expected to drop them from the rows before:

```ruby
require 'active_support/core_ext/hash/except'

transform { |r| r.except(:some_field) }

destination Kiba::Common::Destinations::CSV,
  filename: 'output.csv'
```

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

A way to color-dump rows on the screen, useful at development time while you are looking at the data (requires the `awesome_print` gem).

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

(agreement below borrowed from Sidekiq Legal)

By submitting a Pull Request, you disavow any rights or claims to any changes submitted to the Kiba Common project and assign the copyright of those changes to LoGeek SARL.

If you cannot or do not want to reassign those rights (your employment contract for your employer may not allow this), you should not submit a PR. Open an issue and someone else can do the work.

This is a legal way of saying "If you submit a PR to us, that code becomes ours". 99.9% of the time that's what you intend anyways; we hope it doesn't scare you away from contributing.
