# -*- encoding: utf-8 -*-
require File.expand_path('../lib/kiba-common/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Thibaut Barrère']
  gem.email         = ['thibaut.barrere@gmail.com']
  gem.description   = gem.summary = 'Commonly used helpers for Kiba ETL'
  gem.homepage      = 'https://github.com/thbar/kiba-common'
  gem.license       = 'LGPL-3.0'
  gem.files         = `git ls-files | grep -Ev '^(examples)'`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = 'kiba-common'
  gem.require_paths = ['lib']
  gem.version       = Kiba::Common::VERSION

  gem.add_dependency 'kiba', '~> 1.0.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'awesome_print'
end
