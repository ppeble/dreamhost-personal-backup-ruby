require 'rsync'

module DreamhostPersonalBackup

  class MissingConfigParameter < StandardError; end

  module Backup
    RSYNC_COMMAND_ARGS = ['-e ssh', '-avzP', '--delete']

    def self.run_for_target_directory(target_dir, config_parameters)
      check_for_required_parameters(config_parameters)

      user = config_parameters[:user]
      host = config_parameters[:host]
      logger = config_parameters[:logger]

      target_dir = File.expand_path(target_dir)

      logger.info("  Running backup for target directory: #{target_dir}")
      result = Rsync.run(target_dir, "#{user}@#{host}:~/", RSYNC_COMMAND_ARGS)
      logger.info("  Backup complete, success?: #{result.success?}")

      result.success?
    end

    private

      def self.check_for_required_parameters(config_parameters)
        raise MissingConfigParameter if config_parameters[:user].nil?
        raise MissingConfigParameter if config_parameters[:host].nil?
        raise MissingConfigParameter if config_parameters[:logger].nil?
      end
  end

end
