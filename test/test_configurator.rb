require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

require 'backup/configurator'

class ConfiguratorTests < Test::Unit::TestCase

  def setup
    @configurator = DreamhostPersonalBackup::Configurator.new
  end

  def test_raise_error_if_config_file_does_not_exist
    assert_raise(DreamhostPersonalBackup::ConfigFileNotFoundError) {
      @configurator.load_config_file("/file/does/not/exist")
    }
  end

  def test_config_parameters_set_without_error_from_valid_file
    @configurator.load_config_file('test/test_files/test_standard_config_file.yml')

    assert_equal "testuser", @configurator.get_parameter(:user)
    assert_equal "testhost.com", @configurator.get_parameter(:host)
    assert_equal "TestEmail@email.com", @configurator.get_parameter(:notifyemail)

    assert @configurator.get_parameter(:targets).is_a?(Hash)
  end

  def test_raise_error_if_invalid_parameter_is_passed
    assert_raise(DreamhostPersonalBackup::InvalidConfigParameterError) {
      @configurator.load_config_file('test/test_files/test_invalid_parameters.yml')
    }
  end

  def test_all_targets_set_as_expected
    @configurator.load_config_file('test/test_files/test_standard_config_file.yml')

    assert_equal "~/music", @configurator.get_parameter(:targets)["Music"]
    assert_equal "~/movies", @configurator.get_parameter(:targets)["Movies"]
    assert_equal "~/photos", @configurator.get_parameter(:targets)["Photos"]
  end

  def test_default_log_size_set_if_not_present_in_config_file
    @configurator.load_config_file('test/test_files/test_config_file_missing_optional_params.yml')

    assert_equal DreamhostPersonalBackup::Configurator::DEFAULT_LOG_SIZE,
                 @configurator.get_parameter(:logrotationsizeinbytes)
  end

  def test_default_log_file_keep_count_set_if_not_present_in_config_file
    @configurator.load_config_file('test/test_files/test_config_file_missing_optional_params.yml')

    assert_equal DreamhostPersonalBackup::Configurator::DEFAULT_LOG_KEEP_COUNT,
                 @configurator.get_parameter(:logkeepcount)
  end
end