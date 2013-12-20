require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

require 'backup/backup'

class BackupTests < Test::Unit::TestCase

  CONFIG_PARAMETERS = {:user => "testuser", :host => "localhost"}

  SOURCE_DIR_PARAMETER = "/path/to/source"
  DEST_DIR_PARAMETER = "#{CONFIG_PARAMETERS[:user]}@#{CONFIG_PARAMETERS[:host]}:~/"

  def test_backup_is_performed_without_errors
    set_expected_rsync_result_as(true)
    assert DreamhostPersonalBackup::Backup.run_for_target_directory(SOURCE_DIR_PARAMETER, CONFIG_PARAMETERS)
  end

  def test_backup_fails_if_user_is_missing
    parameters_with_host_only = {:host => "localhost"}

    assert_equal false,
                 DreamhostPersonalBackup::Backup.run_for_target_directory(SOURCE_DIR_PARAMETER, parameters_with_host_only)
  end

  def test_backup_fails_if_host_is_missing
    parameters_with_user_only = {:user => "testuser"}

    assert_equal false,
                 DreamhostPersonalBackup::Backup.run_for_target_directory(SOURCE_DIR_PARAMETER, parameters_with_user_only)
  end

  private

  def set_expected_rsync_result_as(rsync_return_code)
    rsync_return_code = stub(success?: rsync_return_code)

    Rsync.expects(:run).with(SOURCE_DIR_PARAMETER,
                             DEST_DIR_PARAMETER,
                             DreamhostPersonalBackup::Backup::RSYNC_COMMAND_ARGS).returns(rsync_return_code)
  end

end