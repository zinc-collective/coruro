require 'mail'

require_relative 'coruro/version'

require_relative 'coruro/message'

require_relative 'coruro/mailcatcher_adapter'

class Coruro
  attr_accessor :adapter
  extend Forwardable
  def_delegators :adapter, :all, :where, :stop

  def initialize(adapter:, on_wait_tick: -> (count) { }, timeout: 1.0, adapter_config: {})
    if adapters.key?(adapter)
      self.adapter = adapters[adapter].new(timeout: timeout, config: adapter_config)
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


  def adapters
    self.class.adapters
  end

  def self.adapters
    @adapters ||= { mailcatcher: MailcatcherAdapter }
  end
end

