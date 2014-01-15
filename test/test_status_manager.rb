require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

require 'backup/status_manager'

class StatusManagerTests < Test::Unit::TestCase

  def test_is_backup_running_returns_false_if_no_pid_file_is_found
    File.expects(:file?).with(File.expand_path(DreamhostPersonalBackup::StatusManager::PID_FILE)).at_least(1).returns(false)

    assert_equal false, DreamhostPersonalBackup::StatusManager.is_backup_running?
  end

  def test_is_backup_running_returns_true_if_pid_file_is_found_and_pid_is_running
    File.expects(:file?).with(File.expand_path(DreamhostPersonalBackup::StatusManager::PID_FILE)).at_least(1).returns(true)

    file_handle = stub(read: "100")
    File.expects(:open).at_least(1).returns(file_handle)

    Process.expects(:getpgid).at_least(1)

    assert DreamhostPersonalBackup::StatusManager.is_backup_running?
  end

  def test_is_backup_running_returns_false_if_pid_file_is_found_and_pid_is_not_running
    File.expects(:file?).with(File.expand_path(DreamhostPersonalBackup::StatusManager::PID_FILE)).at_least(1).returns(true)

    file_handle = stub(read: "100")
    File.expects(:open).at_least(1).returns(file_handle)

    Process.expects(:getpgid).at_least(1).raises(Errno::ESRCH)

    assert_equal false, DreamhostPersonalBackup::StatusManager.is_backup_running?
  end
end