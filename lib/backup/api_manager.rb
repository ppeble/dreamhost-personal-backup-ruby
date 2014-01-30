require 'httparty'

module DreamhostPersonalBackup

  class UsageDataNotFoundError < StandardError; end

  module ApiManager

    API_ROOT = 'https://api.dreamhost.com/?format=json'
    SIZE_LIMIT_IN_MB = 51200  # This is the value stated on the DH wiki: http://wiki.dreamhost.com/Personal_Backup

    def self.get_current_usage(configurator)
      return if configurator.get_parameter(:api_key).nil?

      api_url = build_api_url('user-list_users', configurator.get_parameter(:api_key))
      response = HTTParty.get(api_url)
      response_json = JSON.parse(response.body)

      if response_json["result"] != "success"
        raise DreamhostPersonalBackup::UsageDataNotFoundError, "API call to determine current usage failed, details: #{determine_error_message(response_json)}"
      end

      current_usage_in_mb = find_usage_data_in_response(response_json, configurator.get_parameter(:user))

      if current_usage_in_mb.nil?
        raise DreamhostPersonalBackup::UsageDataNotFoundError, "Unable to find usage data for user #{configurator.get_parameter(:user)}!"
      end

      current_usage_in_mb
    end

    def self.exceeds_usage_limit?(configurator)
      return false if configurator.get_parameter(:api_key).nil?

      current_usage_in_mb = get_current_usage(configurator)

      current_usage_in_mb >= SIZE_LIMIT_IN_MB
    end

    def self.near_usage_limit?(configurator)
      return false if configurator.get_parameter(:api_key).nil?

      current_usage_in_mb =  get_current_usage(configurator)

      current_usage_in_mb >= (SIZE_LIMIT_IN_MB * 0.90)
    end

    private

    def self.build_api_url(api_command, api_key)
      API_ROOT + "&cmd=#{api_command}&key=#{api_key}"
    end

    def self.find_usage_data_in_response(response, username)
      return unless response.has_key?("data")

      current_usage_in_mb = nil

      response["data"].each do |entry|
        if entry["type"] == "backup" && entry["username"] == username
          current_usage_in_mb = entry["disk_used_mb"].to_i
          break
        end
      end

      current_usage_in_mb
    end

    def self.determine_error_message(response)
      response["reason"].nil? ? response["data"] : response["reason"]
    end

  end

end