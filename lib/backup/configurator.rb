require 'yaml'

module DreamhostPersonalBackup

  class ConfigFileNotFoundError < StandardError; end
  class InvalidConfigParameterError < StandardError; end

  class Configurator
    VALID_CONFIG_PARAMETERS = [:user,
                               :host,
                               :logfile,
                               :targets,
                               :notifyemail,
                               :logrotationsizeinbytes,
                               :logkeepcount,
                               :api_key,
                               :stop_on_usage_warning].freeze

    DEFAULT_CONFIG_FILE = '~/.dreamhost_personal_backup/default_config.yml'
    DEFAULT_LOG_SIZE = 105000000
    DEFAULT_LOG_KEEP_COUNT = 3

    def initialize
      @config_parameters = Hash.new
    end

    def process_config_file(config_file_path = nil)
      config_file_path ||= DEFAULT_CONFIG_FILE
      config_file = File.expand_path(config_file_path)

      raise DreamhostPersonalBackup::ConfigFileNotFoundError unless File.file?(config_file)

      config_file = YAML.load_file(config_file)
      config_file.each do |config_key, config_value|
        config_parameter = config_key.downcase.to_sym

        raise DreamhostPersonalBackup::InvalidConfigParameterError unless VALID_CONFIG_PARAMETERS.include?(config_parameter)

        @config_parameters[config_parameter] = config_value
      end

      check_for_required_parameters

      set_default_values

      @config_parameters.freeze
    end

    def get_parameter(key)
      @config_parameters[key] unless @config_parameters.nil?
    end

    private

    def check_for_required_parameters
      raise DreamhostPersonalBackup::RequiredParameterNotFoundError unless @config_parameters.has_key?(:user)
      raise DreamhostPersonalBackup::RequiredParameterNotFoundError unless @config_parameters.has_key?(:host)
      raise DreamhostPersonalBackup::RequiredParameterNotFoundError unless @config_parameters.has_key?(:targets)
    end

    def set_default_values
      @config_parameters[:logrotationsizeinbytes] = DEFAULT_LOG_SIZE unless @config_parameters.has_key?(:logrotationsizeinbytes)
      @config_parameters[:logkeepcount] = DEFAULT_LOG_KEEP_COUNT unless @config_parameters.has_key?(:logkeepcount)
    end
  end
end