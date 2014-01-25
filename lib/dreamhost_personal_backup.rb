require 'backup/configurator'
require 'backup/backup'
require 'backup/status_manager'
require 'backup/backup_logger'

module DreamhostPersonalBackup
  VERSION = '0.1.0'

  def self.perform_backup(config_file)
    return if DreamhostPersonalBackup::StatusManager.is_backup_running?

    DreamhostPersonalBackup::StatusManager.create_pid_file

    configurator = DreamhostPersonalBackup::Configurator.new
    configurator.process_config_file(config_file)

    DreamhostPersonalBackup.logger.new(configurator)

    DreamhostPersonalBackup.logger.info("")
    DreamhostPersonalBackup.logger.info("Starting new backup run at #{DateTime.now}")

    configurator.get_parameter(:targets).each_value do |target|
      DreamhostPersonalBackup::Backup.run_for_target_directory(target, configurator)
    end

    DreamhostPersonalBackup::StatusManager.remove_pid_file

    DreamhostPersonalBackup.logger.info("Backup run completed at #{DateTime.now}")
  end

end