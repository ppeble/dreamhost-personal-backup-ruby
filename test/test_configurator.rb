require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

require 'backup/configurator'

class ConfiguratorTests < Test::Unit::TestCase

  def test_raise_error_if_config_file_does_not_exist
    assert_raise(DreamhostPersonalBackup::ConfigFileNotFound) {
      DreamhostPersonalBackup::Configurator.process_config_file("/file/does/not/exist")
    }
  end

  def test_config_file_is_processed_without_errors
    config_parameters = DreamhostPersonalBackup::Configurator.process_config_file('test/test_files/test_standard_config_file.yml')
    assert config_parameters.is_a?(Hash), "Config parameters should be a hash"
  end

  def test_config_parameters_set_without_error_from_valid_file
    config_parameters = DreamhostPersonalBackup::Configurator.process_config_file('test/test_files/test_standard_config_file.yml')

    assert_equal "testuser", config_parameters[:user]
    assert_equal "testhost.com", config_parameters[:host]
    assert_equal "TestEmail@email.com", config_parameters[:notifyemail]

    assert config_parameters[:targets].is_a?(Hash)
  end

  def test_raise_error_if_invalid_parameter_is_passed
    assert_raise(DreamhostPersonalBackup::InvalidConfigParameter) {
      DreamhostPersonalBackup::Configurator.process_config_file('test/test_files/test_invalid_parameters.yml')
    }
  end

  def test_all_targets_set_as_expected
    config_parameters = DreamhostPersonalBackup::Configurator.process_config_file('test/test_files/test_standard_config_file.yml')

    assert_equal "~/music", config_parameters[:targets]["Music"]
    assert_equal "~/movies", config_parameters[:targets]["Movies"]
    assert_equal "~/photos", config_parameters[:targets]["Photos"]
  end

  def test_default_log_size_set_if_not_present_in_config_file
    config_parameters = DreamhostPersonalBackup::Configurator.process_config_file('test/test_files/test_config_file_missing_optional_params.yml')

    assert_equal DreamhostPersonalBackup::Configurator::DEFAULT_LOG_SIZE, config_parameters[:logrotationsizeinbytes]
  end

  def test_default_log_file_keep_count_set_if_not_present_in_config_file
    config_parameters = DreamhostPersonalBackup::Configurator.process_config_file('test/test_files/test_config_file_missing_optional_params.yml')

    assert_equal DreamhostPersonalBackup::Configurator::DEFAULT_LOG_KEEP_COUNT, config_parameters[:logkeepcount]
  end

  def test_logger_created_even_if_no_parameters_set
    config_parameters = DreamhostPersonalBackup::Configurator.process_config_file('test/test_files/test_config_file_missing_optional_params.yml')

    assert_not_nil config_parameters[:logger]
  end
end