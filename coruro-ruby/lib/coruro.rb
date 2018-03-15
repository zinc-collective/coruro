require 'mail'

require_relative 'coruro/version'

require_relative 'coruro/message'

require_relative 'coruro/mailcatcher_adapter'

class Coruro
  attr_accessor :adapter
  extend Forwardable
  def_delegators :adapter, :all, :where, :stop

  def initialize(adapter:, on_wait_tick: -> (count) { }, timeout: 1.0, adapter_config: {})
    case adapter
    when :mailcatcher
      self.adapter = MailcatcherAdapter.new(timeout: timeout, config: adapter_config)
      self.adapter.start unless self.adapter.up?
    else
      raise UnrecognizedAdapterError, adapter
    end

    wait_until_up(on_wait_tick)
  end

  def wait_until_up(on_tick)
    count = 0
    until adapter.up? || count > 5
      on_tick.call(count)
      sleep(1)
      count = count + 1
    end
  end

  class UnrecognizedAdapterError < StandardError; end
end

