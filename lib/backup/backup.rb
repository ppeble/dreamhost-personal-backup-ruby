require 'rsync'

module DreamhostPersonalBackup

  class MissingConfigParameterError < StandardError; end

  module Backup
    RSYNC_COMMAND_ARGS = ['-e ssh', '-avzP', '--delete']

    def self.run_for_target_directory(target_dir, config_parameters)
      check_for_required_parameters(config_parameters)

      user = config_parameters[:user]
      host = config_parameters[:host]
      logger = config_parameters[:logger]

      target_dir = File.expand_path(target_dir)

      logger.info("  Running backup for target directory: #{target_dir}")

      rsync_result = Rsync.run(target_dir, "#{user}@#{host}:~/", RSYNC_COMMAND_ARGS)

      log_rsync_result(rsync_result, logger)

      rsync_result.success?
    end

    private

    def self.check_for_required_parameters(config_parameters)
      raise MissingConfigParameterError if config_parameters[:user].nil?
      raise MissingConfigParameterError if config_parameters[:host].nil?
      raise MissingConfigParameterError if config_parameters[:logger].nil?
    end

    def self.log_rsync_result(rsync_result, logger)
      if rsync_result.success?
        if rsync_result.changes.count > 0
          logger.info("  Results:")

          rsync_result.changes.each do |change|
            logger.info "   #{change.summary} - #{change.filename}"
          end
        else
          logger.info("   No changes took place!")
        end

        logger.info("  Backup completed successfully")
      else
        logger.error("  Backup failed, error: #{rsync_result.error}")
      end
    end
  end

end
