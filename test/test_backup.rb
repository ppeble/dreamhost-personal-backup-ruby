require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

require 'backup/backup'
require 'backup/configurator'
require 'backup/backup_logger'
require 'backup/errors'
require 'backup/backup_result_report'

class BackupTests < Test::Unit::TestCase

  CONFIG_PARAMETERS = {user: "testuser", host: "localhost"}

  SOURCE_DIR_PARAMETER = "/path/to/source"
  DEST_DIR_PARAMETER = "#{CONFIG_PARAMETERS[:user]}@#{CONFIG_PARAMETERS[:host]}:~/"

  def setup
    @configurator = DreamhostPersonalBackup::Configurator.new

    set_expected_config_value(:user, CONFIG_PARAMETERS[:user])
    set_expected_config_value(:host, CONFIG_PARAMETERS[:host])
  end

  def test_run_is_performed_without_errors_with_updated_file
    set_expected_rsync_result_as(true)

    backup = DreamhostPersonalBackup::Backup.new(SOURCE_DIR_PARAMETER, @configurator)

    assert backup.run
  end

  def test_run_returns_false_if_rsync_reports_an_error
    set_expected_rsync_result_as(false)

    backup = DreamhostPersonalBackup::Backup.new(SOURCE_DIR_PARAMETER, @configurator)

    assert_equal false, backup.run
  end

  def test_initialize_raises_missing_parameter_error_if_user_is_missing
    set_expected_config_value(:user, nil)

    assert_raise(DreamhostPersonalBackup::RequiredParameterNotFoundError) {
      DreamhostPersonalBackup::Backup.new(SOURCE_DIR_PARAMETER, @configurator)
    }
  end

  def test_initialize_raises_missing_parameter_error_if_host_is_missing
    set_expected_config_value(:host, nil)

    assert_raise(DreamhostPersonalBackup::RequiredParameterNotFoundError) {
      DreamhostPersonalBackup::Backup.new(SOURCE_DIR_PARAMETER, @configurator)
    }
  end

  def test_generate_result_report_calls_default_reporter_if_no_parameter_are_passed
    DreamhostPersonalBackup::BackupResultReport.any_instance.expects(:generate_for).returns(nil)

    backup = DreamhostPersonalBackup::Backup.new(SOURCE_DIR_PARAMETER, @configurator)
    backup.generate_result_report
  end

  private

  def set_expected_rsync_result_as(rsync_return_code)
    rsync_change = stub(:summary => "timestamp", :filename => "test.dat")

    rsync_change_array = Array.new
    rsync_change_array << rsync_change

    rsync_result = stub(:success? => rsync_return_code, :changes => rsync_change_array, :error => "rsync example error")

    Rsync.expects(:run).with(SOURCE_DIR_PARAMETER,
                             DEST_DIR_PARAMETER,
                             DreamhostPersonalBackup::Backup::RSYNC_COMMAND_ARGS).returns(rsync_result)
  end


end