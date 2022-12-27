require File.expand_path("../lib/kiba-common/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Thibaut Barrère"]
  gem.email = ["thibaut.barrere@gmail.com"]
  gem.description = gem.summary = "Commonly used helpers for Kiba ETL"
  gem.homepage = "https://github.com/thbar/kiba-common"
  gem.license = "LGPL-3.0"
  gem.files = `git ls-files | grep -Ev '^(examples)'`.split("\n")
  # NOTE: temporarily disabled until
  # https://github.com/rubocop/rubocop/issues/10675 is fixed
  # gem.test_files = `git ls-files -- test/*`.split("\n")
  gem.name = "kiba-common"
  gem.require_paths = ["lib"]
  gem.version = Kiba::Common::VERSION
  gem.metadata = {
    "source_code_uri" => "https://github.com/thbar/kiba-common",
    "documentation_uri" => "https://github.com/thbar/kiba-common/blob/master/README.md"
  }

  gem.add_dependency "kiba", ">= 3.0.0", "< 5"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "amazing_print"
  gem.add_development_dependency "minitest-focus"
  gem.add_development_dependency "standard"
end
