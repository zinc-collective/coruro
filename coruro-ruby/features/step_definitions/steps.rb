Given(/Coruro has started the (.*) adapter/) do |adapter|
  @coruro = Coruro.new(adapter: adapter.to_sym,
                       adapter_config: { expose_streams: { stdout: $stdout, stderr: $stderr } })
end

Given(/the (.*) adapter is not already running/) do |adapter|
 Coruro.new(adapter: adapter.to_sym).stop
end

When(/I instantiate Coruro with the (.*) adapter/) do |adapter|
  @coruro = Coruro.new(adapter: adapter.to_sym,
                       adapter_config: { expose_streams: { stdout: $stdout, stderr: $stderr } })
end

When(/I stop Coruro with the (.*) adapter/) do |adapter|
  @coruro.stop
end


Then(/Coruro knows the (.*) adapter is up/) do |adapter|
  assert @coruro.adapter.up?
end

Then(/Coruro knows the (.*) adapter is not up/) do |adapter|
  assert !@coruro.adapter.up?
end
