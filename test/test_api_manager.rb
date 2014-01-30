require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

require 'backup/api_manager'

class ApiManagerTests < Test::Unit::TestCase

  CONFIG_PARAMETERS = {user: "TestUser", api_key: "TEST_API_KEY"}

  def setup
    @configurator = DreamhostPersonalBackup::Configurator.new

    set_expected_config_value(:user, CONFIG_PARAMETERS[:user])
    set_expected_config_value(:api_key, CONFIG_PARAMETERS[:api_key])

    #FIXME I need a better way to build expected HTTParty responses, creating these strings is dumb
  end

  def test_get_current_usage_returns_nil_if_api_key_is_not_specified
    set_expected_config_value(:api_key, nil)

    assert_nil DreamhostPersonalBackup::ApiManager.get_current_usage(@configurator)
  end

  def test_get_current_usage_raises_error_if_api_call_does_not_return_success
    httparty_response = stub(body: "{}")
    HTTParty.expects(:get).returns(httparty_response)

    assert_raise(DreamhostPersonalBackup::UsageDataNotFoundError) {
      DreamhostPersonalBackup::ApiManager.get_current_usage(@configurator)
    }
  end

  def test_get_current_usage_raises_error_if_backup_user_data_is_not_in_response
    httparty_response = stub(body: "{\"result\": \"success\"}")
    HTTParty.expects(:get).returns(httparty_response)

    assert_raise(DreamhostPersonalBackup::UsageDataNotFoundError) {
      DreamhostPersonalBackup::ApiManager.get_current_usage(@configurator)
    }
  end

  def test_get_current_usage_returns_expected_result
    httparty_response = stub(body: "{\"result\": \"success\", \"data\": [{\"type\": \"backup\", \"disk_used_mb\":\"100\",\"username\":\"#{CONFIG_PARAMETERS[:user]}\"}]}")
    HTTParty.expects(:get).returns(httparty_response)

    assert_equal 100, DreamhostPersonalBackup::ApiManager.get_current_usage(@configurator)
  end

  def test_exceeds_usage_limit_returns_false_if_api_key_is_not_present
    set_expected_config_value(:api_key, nil)

    assert_equal false, DreamhostPersonalBackup::ApiManager.exceeds_usage_limit?(@configurator)
  end

  def test_exceeds_usage_limit_returns_true_if_limit_is_actually_exceeded
    httparty_response = stub(body: "{\"result\": \"success\", \"data\": [{\"type\": \"backup\", \"disk_used_mb\":\"50000000\",\"username\":\"#{CONFIG_PARAMETERS[:user]}\"}]}")
    HTTParty.expects(:get).returns(httparty_response)

    assert DreamhostPersonalBackup::ApiManager.exceeds_usage_limit?(@configurator)
  end

  def test_exceeds_usage_limit_returns_false_if_limit_has_not_been_reached
    httparty_response = stub(body: "{\"result\": \"success\", \"data\": [{\"type\": \"backup\", \"disk_used_mb\":\"1\",\"username\":\"#{CONFIG_PARAMETERS[:user]}\"}]}")
    HTTParty.expects(:get).returns(httparty_response)

    assert_equal false, DreamhostPersonalBackup::ApiManager.exceeds_usage_limit?(@configurator)
  end

  def test_near_usage_limit_returns_false_if_api_key_is_not_present
    set_expected_config_value(:api_key, nil)

    assert_equal false, DreamhostPersonalBackup::ApiManager.near_usage_limit?(@configurator)
  end

  def test_near_usage_limit_returns_true_if_current_usage_is_within_10_percent_of_limit
    httparty_response = stub(body: "{\"result\": \"success\", \"data\": [{\"type\": \"backup\", \"disk_used_mb\":\"50000\",\"username\":\"#{CONFIG_PARAMETERS[:user]}\"}]}")
    HTTParty.expects(:get).returns(httparty_response)

    assert DreamhostPersonalBackup::ApiManager.near_usage_limit?(@configurator)
  end

  def test_near_usage_limit_returns_false_if_current_usage_is_not_within_10_percent_of_limit
    httparty_response = stub(body: "{\"result\": \"success\", \"data\": [{\"type\": \"backup\", \"disk_used_mb\":\"1\",\"username\":\"#{CONFIG_PARAMETERS[:user]}\"}]}")
    HTTParty.expects(:get).returns(httparty_response)

    assert_equal false, DreamhostPersonalBackup::ApiManager.near_usage_limit?(@configurator)
  end
end