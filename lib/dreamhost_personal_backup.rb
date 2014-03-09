require 'backup/configurator'
require 'backup/backup'
require 'backup/status_manager'
require 'backup/backup_logger'
require 'backup/api_manager'
require 'backup/backup_result_report'

module DreamhostPersonalBackup
  VERSION = '0.1.0'

  def self.perform_backup(config_file)
    configurator = DreamhostPersonalBackup::Configurator.new
    configurator.load_config_file(config_file)

    DreamhostPersonalBackup.instantiate_logger(configurator)

    if DreamhostPersonalBackup::StatusManager.is_backup_running?
      DreamhostPersonalBackup.logger.info("Backup is already running! Exiting ...")
      exit
    end

    DreamhostPersonalBackup::StatusManager.begin_run

    #FIXME This should probably be in its own method
    if DreamhostPersonalBackup::ApiManager.exceeds_usage_limit?(configurator) && configurator.get_parameter(:stoponusagewarning)
      usage_before_backup_in_mb = DreamhostPersonalBackup::ApiManager.get_current_usage(configurator)

      DreamhostPersonalBackup.logger.info("")
      DreamhostPersonalBackup.logger.warn("  You have met or exceeded the usage limit allowed by Dreamhost. Current usage (mb): #{usage_before_backup_in_mb}")
      DreamhostPersonalBackup.logger.error('  You have specified that you wish to stop the backup on a usage warning, shutting down without making any changes.')
      exit

      #FIXME Send notification email if email parameter is present
    end

    backups = create_backups(configurator)
    run(backups)

    #FIXME This should probably be in its own method
    if DreamhostPersonalBackup::ApiManager.near_usage_limit?(configurator) || DreamhostPersonalBackup::ApiManager.exceeds_usage_limit?(configurator)
      usage_after_backup_in_mb = DreamhostPersonalBackup::ApiManager.get_current_usage(configurator)

      DreamhostPersonalBackup.logger.info("")
      DreamhostPersonalBackup.logger.warn("  You are at or near the usage limit allowed by Dreamhost. If you exceed the limit you will be charged by Dreamhost for additional usage. Current usage (mb): #{usage_after_backup_in_mb}")

      #FIXME Send warning email if the email parameter is present
    end

  end

  private

  def self.create_backups(configurator)
    backups = Array.new

    configurator.get_parameter(:targets).each_value do |target|
      backups << DreamhostPersonalBackup::Backup.new(target, configurator)
    end

    backups
  end

  def self.run(backups)
    backups.each do |backup|
      DreamhostPersonalBackup.logger.info("")
      DreamhostPersonalBackup.logger.info("  Running backup for target directory: #{backup.target_directory}")

      backup.run
      result_report = backup.generate_result_report

      DreamhostPersonalBackup.logger.info(result_report)
    end
  end

end