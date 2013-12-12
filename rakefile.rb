$:.unshift File.expand_path('../lib', __FILE__)

require 'rake'
require 'rake/testtask'
require 'rdoc/task'

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