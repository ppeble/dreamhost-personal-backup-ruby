require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

require 'backup/backup'
require 'logger'

class BackupTests < Test::Unit::TestCase

  CONFIG_PARAMETERS = {:user => "testuser", :host => "localhost", :logger => Logger.new(STDOUT)}

  SOURCE_DIR_PARAMETER = "/path/to/source"
  DEST_DIR_PARAMETER = "#{CONFIG_PARAMETERS[:user]}@#{CONFIG_PARAMETERS[:host]}:~/"

  def test_backup_is_performed_without_errors_with_updated_file
    set_expected_rsync_result_as(true)
    assert DreamhostPersonalBackup::Backup.run_for_target_directory(SOURCE_DIR_PARAMETER, CONFIG_PARAMETERS)
  end

  def test_backup_returns_failure_if_rsync_reports_an_error
    set_expected_rsync_result_as(false)
    assert_equal false, DreamhostPersonalBackup::Backup.run_for_target_directory(SOURCE_DIR_PARAMETER, CONFIG_PARAMETERS)
  end

  def test_backup_fails_if_user_is_missing
    parameters_with_host_only = {:host => "localhost"}

    assert_raise(DreamhostPersonalBackup::MissingConfigParameter) {
      DreamhostPersonalBackup::Backup.run_for_target_directory(SOURCE_DIR_PARAMETER, parameters_with_host_only)
    }
  end

  def test_backup_fails_if_host_is_missing
    parameters_with_user_only = {:user => "testuser"}

    assert_raise(DreamhostPersonalBackup::MissingConfigParameter) {
      DreamhostPersonalBackup::Backup.run_for_target_directory(SOURCE_DIR_PARAMETER, parameters_with_user_only)
    }
  end

  private

  def set_expected_rsync_result_as(rsync_return_code)
    rsync_change = stub(:summary => "timestamp", :filename => "test.dat")

    rsync_change_array = Array.new
    rsync_change_array.push(rsync_change)

    rsync_return_code = stub(:success? => rsync_return_code, :changes => rsync_change_array, :error => "rsync example error")

    suppress_logging_messages

    Rsync.expects(:run).with(SOURCE_DIR_PARAMETER,
                             DEST_DIR_PARAMETER,
                             DreamhostPersonalBackup::Backup::RSYNC_COMMAND_ARGS).returns(rsync_return_code)
  end

  def suppress_logging_messages
    Logger.any_instance.expects(:info).at_least(0).returns(nil)
    Logger.any_instance.expects(:error).at_least(0).returns(nil)
  end

end