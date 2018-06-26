require 'coruro'

require 'minitest/spec'

class MinitestWorld
  include Minitest::Assertions
  attr_accessor :assertions

  def initialize
    self.assertions = 0
  end
end

World do
  MinitestWorld.new
end

class CustomAdapter
  attr_accessor :config
  def initialize(config:, timeout:)
  end

  def up?
    runner.up?(config)
  end

  def start
    runner.start(config)
  end

  def stop
    runner.stop
  end

  def runner
    @_runner ||= Runner.instance
  end

  class Runner
    include Singleton
    attr_accessor :up


    def start(config)
      self.up = true
    end

    def up?(config)
      !!up
    end

    def stop
      self.up = false;
    end
  end
end

Coruro.adapters[:custom] = CustomAdapter;

at_exit do
  [:mailcatcher, :custom].each do |adapter|
    Coruro.new(adapter: adapter).stop
  end
end
