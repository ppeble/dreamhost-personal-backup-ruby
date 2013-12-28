$:.unshift File.expand_path('../lib', __FILE__)

require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'dreamhost_personal_backup'

task :default => :test

desc 'Run all tests'
task :test => ["test:lib"]

namespace :test do

  desc 'Run gem tests.'
  Rake::TestTask.new(:lib) do |t|
    t.libs << 'lib'
    t.test_files = FileList['test/test*.rb'].exclude('test_helper.rb')
    t.verbose = false
  end
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "dreamhost-personal-backup"
    gemspec.summary = "Provides functionality to perform personal backups (on Linux or OSX) to a Dreamhost personal backup server."
    gemspec.description = "Provides functionality to perform personal backups (on Linux or OSX) to a Dreamhost personal backup server."
    gemspec.email = "philtrimble@gmail.com"
    gemspec.homepage = "https://github.com/ptrimble/dreamhost-personal-backup"
    gemspec.version = DreamhostPersonalBackup::VERSION
    gemspec.authors = ["Phil Trimble"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end