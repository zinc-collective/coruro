$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "coruro"

require "minitest/autorun"

Minitest.after_run do
  coruro = Coruro.new(adapter: :mailcatcher)
  coruro.stop
end
