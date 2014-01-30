require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter
]

SimpleCov.start do
  add_filter 'test'
end

$:.unshift(File.expand_path(File.dirname(__FILE__) + '../../lib/'))

$KCODE = 'u' if RUBY_VERSION =~ /^1\.8/

require 'rubygems'
require 'test/unit'

require 'mocha/setup'  # The mocha docs state that this MUST come after the require for test/unit

def set_expected_config_value(parameter, value)
  DreamhostPersonalBackup::Configurator.any_instance.expects(:get_parameter).with(parameter).at_least(0).returns(value)
end