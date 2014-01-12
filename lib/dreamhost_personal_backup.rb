require 'backup/configurator'
require 'backup/backup'

module DreamhostPersonalBackup
  VERSION = '0.1.0'

  def self.perform_backup(config_file)
    config_parameters = DreamhostPersonalBackup::Configurator.process_config_file(config_file)

    logger = config_parameters[:logger]

    # Add some newlines for readability
    logger.info("")
    logger.info("")

    logger.info("Starting new backup run at #{DateTime.now}")

    config_parameters[:targets].each_value do |target|
      DreamhostPersonalBackup::Backup.run_for_target_directory(target, config_parameters)
    end

    logger.info("Backup run completed at #{DateTime.now}")
  end

end