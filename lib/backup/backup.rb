require 'rsync'

module DreamhostPersonalBackup

  class Backup
    RSYNC_COMMAND_ARGS = ['-e ssh', '-avzP', '--delete']

    attr_reader :target_directory

    def initialize(target_dir, configurator)
      @target_directory = File.expand_path(target_dir)
      @user = configurator.get_parameter(:user)
      @host = configurator.get_parameter(:host)

      raise DreamhostPersonalBackup::RequiredParameterNotFoundError if @user.nil? || @host.nil? || @target_directory.nil?
    end

    def run
      @rsync_result = Rsync.run(@target_directory, "#{@user}@#{@host}:~/", RSYNC_COMMAND_ARGS)
      @rsync_result.success?
    end

    def print_results(printer = DreamhostPersonalBackup::BackupResultPrinter)
      printer.new.print(@rsync_result)
    end

  end

end
