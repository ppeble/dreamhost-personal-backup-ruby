require 'simplecov'
SimpleCov.start

$:.unshift(File.expand_path(File.dirname(__FILE__) + '../../lib/'))

$KCODE = 'u' if RUBY_VERSION =~ /^1\.8/

require 'rubygems'
require 'test/unit'

require 'mocha/setup'  # The mocha docs state that this MUST come after the require for test/unit