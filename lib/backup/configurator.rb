require 'yaml'
require 'logger'

module DreamhostPersonalBackup

  class ConfigFileNotFoundError < StandardError; end
  class InvalidConfigParameterError < StandardError; end

  class Configurator

    VALID_CONFIG_PARAMETERS = [:user, :host, :logfile, :targets, :notifyemail, :logrotationsizeinbytes, :logkeepcount]

    DEFAULT_CONFIG_FILE = '~/.dreamhost_personal_backup/default_config.yml'
    DEFAULT_LOG_SIZE = 105000000
    DEFAULT_LOG_KEEP_COUNT = 3

    def self.process_config_file(config_file_path = nil)
      config_file_path ||= DEFAULT_CONFIG_FILE
      config_file = File.expand_path(config_file_path)

      raise DreamhostPersonalBackup::ConfigFileNotFoundError unless File.file?(config_file)

      config_parameters = Hash.new

      config_file = YAML.load_file(config_file)
      config_file.each do |config_key, config_value|
        config_parameter = config_key.downcase.to_sym

        raise DreamhostPersonalBackup::InvalidConfigParameterError unless VALID_CONFIG_PARAMETERS.include?(config_parameter)

        config_parameters[config_parameter] = config_value
      end

      config_parameters = set_default_values_if_necessary(config_parameters)

      config_parameters[:logger] = create_logger(config_parameters)

      config_parameters
    end

    private

    def self.set_default_values_if_necessary(config_parameters)
      config_parameters[:logrotationsizeinbytes] = DEFAULT_LOG_SIZE unless config_parameters.has_key?(:logrotationsizeinbytes)
      config_parameters[:logkeepcount] = DEFAULT_LOG_KEEP_COUNT unless config_parameters.has_key?(:logkeepcount)

      config_parameters
    end

    def self.create_logger(config_parameters)
      logfile = File.expand_path(config_parameters[:logfile]) unless config_parameters[:logfile].nil?
      logfile = STDOUT if logfile.nil?

      Logger.new(logfile,
                 shift_age = config_parameters[:logkeepcount],
                 shift_size = config_parameters[:logrotationsizeinbytes])
    end
  end
end