require 'logger'
require 'singleton'

module DreamhostPersonalBackup

  def self.logger
    DreamhostPersonalBackup::BackupLogger.instance.get
  end

  class BackupLogger
    include Singleton

    def initialize(configurator)
      logfile = File.expand_path(configurator.get_parameter(:logfile)) unless configurator.get_parameter(:logfile).nil?

      logfile = STDOUT if logfile.nil?


      @logger = Logger.new(logfile,
                 shift_age = configurator.get_parameter(:logkeepcount),
                 shift_size = configurator.get_parameter(:logrotationsizeinbytes))
    end

    def get
      @logger
    end
  end
end