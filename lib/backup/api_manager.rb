require 'httparty'

module DreamhostPersonalBackup

  module ApiManager

    API_ROOT = 'https://api.dreamhost.com/?format=json'
    SIZE_LIMIT_IN_MB = 51200  # This is the value stated on the DH wiki: http://wiki.dreamhost.com/Personal_Backup

    def self.check_usage(configurator)
      return if configurator.get_parameter(:api_key).nil?

      api_url = build_api_url('user-list_users', configurator.get_parameter(:api_key))
      response = HTTParty.get(api_url)
      response_json = JSON.parse(response.body)

      DreamhostPersonalBackup.logger.info("")

      if response_json["result"] != "success"
        DreamhostPersonalBackup.logger.warn("response: #{response_json.inspect}")
        DreamhostPersonalBackup.logger.warn("API call to determine current usage failed, details: #{determine_error_message(response_json)}")
        return
      end

      current_usage_in_mb = find_usage_data(response_json, configurator.get_parameter(:user))

      if current_usage_in_mb.nil?
        DreamhostPersonalBackup.logger.warn("Unable to find usage data for user #{configurator.get_parameter(:user)}!")
        return
      end

      if current_usage_in_mb >= SIZE_LIMIT_IN_MB
        DreamhostPersonalBackup.logger.warn("You have exceeded the free storage limit of #{SIZE_LIMIT_IN_MB} MB, current usage: #{current_usage_in_mb} MB")
        #FIXME add email notification logic
      end
    end

    private

    def self.build_api_url(api_command, api_key)
      API_ROOT + "&cmd=#{api_command}&key=#{api_key}"
    end

    def self.find_usage_data(response, username)
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