require 'yaml'

module DreamhostPersonalBackup

  class ConfigFileNotFound < StandardError; end
  class InvalidConfigParameter < StandardError; end

  class Configurator

    VALID_CONFIG_PARAMETERS = [:user, :host, :logfile, :targets, :notifyemail, :logrotationsizeinbytes]

    DEFAULT_CONFIG_FILE = '~/.dreamhost_personal_backup/default_config.yml'
    DEFAULT_LOG_SIZE = 105000000

    def self.process_config_file(config_file_path = nil)
      config_file_path ||= DEFAULT_CONFIG_FILE
      config_file = File.expand_path(config_file_path)

      raise DreamhostPersonalBackup::ConfigFileNotFound unless File.file?(config_file)

      config_parameters = Hash.new
      config_file = YAML.load_file(config_file)

      config_file.each do |config_key, config_value|
        config_parameter = config_key.downcase.to_sym

        raise DreamhostPersonalBackup::InvalidConfigParameter unless VALID_CONFIG_PARAMETERS.include?(config_parameter)

        config_parameters[config_parameter] = config_value
      end

      config_parameters = set_default_values_if_necessary(config_parameters)

      config_parameters
    end

    def self.set_default_values_if_necessary(config_parameters)
      config_parameters[:logrotationsizeinbytes] = DEFAULT_LOG_SIZE unless config_parameters.has_key?(:logrotationsizeinbytes)

      config_parameters
    end
  end
end