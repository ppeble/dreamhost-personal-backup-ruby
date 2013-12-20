require 'logger'
require 'backup/configurator'
require 'backup/backup'

module DreamhostPersonalBackup
  VERSION = '0.1'

  def self.perform_backup(parameters = {})
    config_parameters = DreamhostPersonalBackup::Configurator.process_config_file(parameters[:config_file])

    #logger = Logger.new(config_parameters[:logfile], shift_size = config_parameters[:logrotationsizeinbytes])

    config_parameters[:targets].each_value do |target|
      DreamhostPersonalBackup::Backup.run_for_target_directory(target, config_parameters)
    end
  end

end