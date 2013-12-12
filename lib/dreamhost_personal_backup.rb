require 'logger'
require 'rsync'

module DreamhostPersonalBackup
  VERSION = '0.1'

  RSYNC_COMMAND_ARGS = ['-e ssh', '-avzP', '--delete']

  def self.run_backup_for_target_directory(target_dir, user, server, logger)
    logger.info "Starting backup for #{target_dir}"

    result = Rsync.run(target_dir, "#{user}@#~/", RSYNC_COMMAND_ARGS)

    logger.error "rsync error detected: #{result.error}" unless result.success?

    logger.info "Backup ended!"
  end

  def self.perform_backup(parameters = {})
    config_parameters = DreamhostPersonalBackup::Configurator.process_config_file(parameters[:config_file])

    logger = Logger.new(config_parameters[:logfile], shift_size = config_parameters[:logrotationsizeinbytes])

    run_backup_for_target_directory("/media/sdb1/music/", user, server, logger)
    run_backup_for_target_directory("~/Documents", user, server, logger)
    run_backup_for_target_directory("~/Writing", user, server, logger)
    run_backup_for_target_directory("~/scripts", user, server, logger)
    run_backup_for_target_directory("~/gmail-archive", user, server, logger)
    run_backup_for_target_directory("/Code/patches", user, server, logger)
  end

end