require "test_helper"
require 'Ruby/Changelly/version'
require 'Ruby/Changelly'

class Ruby::ChangellyTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ruby::Changelly::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
  def test_assert_message_sent
    interface = Changelly::Changelly.new()
    interface.
  end
end
