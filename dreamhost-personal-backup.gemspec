# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in rakefile.rb, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dreamhost-personal-backup"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Phil Trimble"]
  s.date = "2014-01-13"
  s.description = "Provides functionality to perform personal backups (on Linux or OSX) to a Dreamhost personal backup server."
  s.email = "philtrimble@gmail.com"
  s.executables = ["dreamhost_personal_backup"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".coveralls.yml",
    ".travis.yml",
    "CHANGELOG",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.rdoc",
    "bin/dreamhost_personal_backup",
    "dreamhost-personal-backup.gemspec",
    "lib/backup/backup.rb",
    "lib/backup/configurator.rb",
    "lib/backup/status_manager.rb",
    "lib/dreamhost_personal_backup.rb",
    "rakefile.rb",
    "test/test_backup.rb",
    "test/test_configurator.rb",
    "test/test_dreamhost_personal_backup.rb",
    "test/test_files/test_config_file_missing_optional_params.yml",
    "test/test_files/test_invalid_parameters.yml",
    "test/test_files/test_standard_config_file.yml",
    "test/test_helper.rb",
    "test/test_status_manager.rb"
  ]
  s.homepage = "https://github.com/ptrimble/dreamhost-personal-backup"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Provides functionality to perform personal backups (on Linux or OSX) to a Dreamhost personal backup server."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rsync>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<coveralls>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<rsync>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<coveralls>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rsync>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<coveralls>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end

