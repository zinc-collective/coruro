require_relative 'coruro/message'

require_relative 'coruro/mailcatcher_adapter'

class Coruro
  attr_accessor :adapter
  extend Forwardable
  def_delegators :adapter, :where, :stop

  def initialize(adapter:, on_wait_tick: -> (count) { })
    case adapter
    when :mailcatcher
      self.adapter = MailcatcherAdapter.new
      self.adapter.start
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
    end
  end

  class UnrecognizedAdapterError < StandardError; end
end
