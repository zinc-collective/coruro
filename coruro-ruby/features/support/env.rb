require 'coruro'

at_exit do
  Coruro.new(adapter: :mailcatcher).stop
end
