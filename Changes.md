HEAD
----

- Breaking: `show_me!` is now compatible with both `awesome_print` and its modern replacement `amazing_print`. You will have to `require` the one you want to use in your code from now on.

1.0.0
-----

- Kiba ETL v3 compatibility
- New: Kiba::Common::Destinations::Lambda lets you write block-form destinations (handy for one-off scripts).

0.9.0
-----

- New: Kiba::Common::Sources::CSV provides a basic CSV source for simple needs.

0.8.0
-----

- Bugfix: `show_me!` used with a block should not modify the processed row.

0.7.0
-----

- New: Kiba::Common::Transforms::SourceTransformAdapter let you transform rows into parameters for source instantiation.

0.6.0
-----

- New: Kiba::Common::Transforms::EnumerableExploder will explode each enumerable row (responding to `#each`) into N rows.

0.5.0
-----

- New: Kiba::Common::Sources::Enumerable allows to use any Ruby instance responding to `#each` (or a `Proc` returning such an instance) as a source for rows.

0.0.4
-----

- Update: Kiba::Common::Destinations:CSV compatibility fix for Ruby 2.5

0.0.3
-----

- Breaking: Kiba::Common requires Ruby 2.3+ from now on.
- New: Kiba::Common::Destinations:CSV allows to write ruby hashes to a CSV file.

0.0.2
----

- Update: `show_me!` can be called with a block to pre-process the row before printing.

0.0.1
-----

- New: Kiba::Common::DSLExtensions::ShowMe (useful to color-print rows during development)
- New: Kiba::Common::DSLExtensions::Logger (production logging)
