require "test_helper"
require 'Changelly/version'
require 'Changelly'
require 'json'

# A low priority work in progress. untested. test_api_key_is_valid is assumed to work

class ChangellyTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ruby::Changelly::VERSION
  end

  def test_it_does_something_useful
    assert true
  end
  def test_api_key_is_valid
    createSettingsFile
    begin
      interface = Changelly::Changelly.new(readApiKey,readApiSecret)
      if interface.send_message
        result=true
      end
    rescue
      result=false
    end
    assert result, "This Api Key is valid"
  end
  def test_assert_message_sent
    createSettingsFile
    interface = Changelly::Changelly.new(readApiKey,readApiSecret)
    assert interface.getCurrencies, "get currencies works"
  end
  # begin helper functions
  def createSettingsFile
    if !File.exists? 'Settings.json'
      puts "Creating Settings.json"
      settings_file = File.new "Settings.json","W"
      settings_hash = {'api_key' => "","api_secret" => "" }

      settings_file.write(JSON.unparse settings_hash)

      puts "Now fill in the file, located where modules are stored. its called Settings.json"
    end
  end
  def readApiKey
    settings_file = File.new "Settings.json","r"
    return JSON.parse(settings_file)['api_key']
  end
  def readApiSecret
    settings_file = File.new "Settings.json","r"
    return JSON.parse(settings_file)['api_secret']
  end
end
