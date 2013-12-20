require 'rsync'

module DreamhostPersonalBackup

  module Backup
    RSYNC_COMMAND_ARGS = ['-e ssh', '-avzP', '--delete']

    def self.run_for_target_directory(target_dir, config_parameters)
      return false if config_parameters[:user].nil?
      return false if config_parameters[:host].nil?

      user = config_parameters[:user]
      host = config_parameters[:host]

      target_dir = File.expand_path(target_dir)

      result = Rsync.run(target_dir, "#{user}@#{host}:~/", RSYNC_COMMAND_ARGS)
      result.success?
    end
  end

end
