require 'rsync'
require 'backup/backup_logger'

module DreamhostPersonalBackup

  module Backup
    RSYNC_COMMAND_ARGS = ['-e ssh', '-avzP', '--delete']

    def self.run_for_target_directory(target_dir, configurator)
      check_for_required_parameters(configurator)

      user = configurator.get_parameter(:user)
      host = configurator.get_parameter(:host)

      target_dir = File.expand_path(target_dir)

      DreamhostPersonalBackup.logger.info("")
      DreamhostPersonalBackup.logger.info("  Running backup for target directory: #{target_dir}")

      rsync_result = Rsync.run(target_dir, "#{user}@#{host}:~/", RSYNC_COMMAND_ARGS)

      log_rsync_result(rsync_result)

      rsync_result.success?
    end

    private

    def self.check_for_required_parameters(configurator)
      raise DreamhostPersonalBackup::RequiredParameterNotFoundError if configurator.get_parameter(:user).nil?
      raise DreamhostPersonalBackup::RequiredParameterNotFoundError if configurator.get_parameter(:host).nil?
    end

    def self.log_rsync_result(rsync_result)
      if rsync_result.success?
        if rsync_result.changes.count > 0
          DreamhostPersonalBackup.logger.info("  Results:")

          rsync_result.changes.each do |change|
            DreamhostPersonalBackup.logger.info("   #{change.summary} - #{change.filename}")
          end
        else
          DreamhostPersonalBackup.logger.info("  No changes took place!")
        end

        DreamhostPersonalBackup.logger.info("  Backup completed successfully")
      else
        DreamhostPersonalBackup.logger.error("  Backup failed, error: #{rsync_result.error}")
      end
    end
  end

end
