require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

require 'backup/backup_result_report'

class BackupResultReportTests < Test::Unit::TestCase

  def setup
    @report = DreamhostPersonalBackup::BackupResultReport.new

    rsync_change = stub(:summary => "timestamp", :filename => "test.dat")

    rsync_change_array = Array.new
    rsync_change_array << rsync_change

    @rsync_result = stub(:success? => true, :changes => rsync_change_array)
  end

  def test_generate_for_raises_error_if_results_are_nil
    assert_raise(ArgumentError) { @report.generate_for(nil) }
  end

  def test_generate_for_returns_a_string
    assert @report.generate_for(@rsync_result)
  end

  def test_generate_for_builds_expected_report_for_single_changed_file
    expected_report_string = "  Results:\n   timestamp - test.dat\n  Backup completed successfully"
    assert_equal expected_report_string, @report.generate_for(@rsync_result)
  end

  def test_generate_for_builds_expected_report_for_failed_result
    error_rsync_result = stub(:success? => false, :error => "rsync example error")

    expected_report_string = "  Backup failed, error: #{error_rsync_result.error}"

    assert_equal expected_report_string, @report.generate_for(error_rsync_result)
  end

  def test_generate_for_builds_expected_report_for_successful_result_with_no_changes
    rsync_result_with_no_changes = stub(:success? => true, :changes => Array.new)

    expected_report_string = "  No changes took place!\n  Backup completed successfully"

    assert_equal expected_report_string, @report.generate_for(rsync_result_with_no_changes)
  end
end