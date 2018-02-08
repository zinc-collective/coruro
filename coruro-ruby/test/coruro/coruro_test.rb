require 'pry'
require "test_helper"
Mail.defaults do
  delivery_method :smtp, address: "localhost", port: 1025
end

class CoruroTest < Minitest::Test
  def setup
    @coruro = Coruro.new(adapter: :mailcatcher, on_wait_tick: -> (count) { print("C") })
    mail = Mail.new do
      to "recipient@example.com"
      from "sender@example.com"
      subject "Hello there!"
      body "I'm an email"
    end
    mail.deliver
  end

  def test_that_it_has_a_version_number
    refute_nil ::Coruro::VERSION
  end

  def test_all
    mails = @coruro.all
    refute_empty(mails)
  end

  def test_where_recipient_matches_to
    mails = @coruro.where(to: /recipient/)
    refute_empty(mails)
    mails.each do |mail|
      assert_includes(mail.to, "recipient@example.com")
    end
  end

  def test_where_subject_matches
    mails = @coruro.where(subject: /Hello/)
    refute_empty(mails)
    mails.each do |mail|
      assert_match(/Hello/, mail.subject)
    end
  end

  def test_where_from_matches
    mails = @coruro.where(from: /sender/)
    refute_empty(mails)
    mails.each do |mail|
      assert_includes(mail.from, "sender@example.com")
    end
  end
end
