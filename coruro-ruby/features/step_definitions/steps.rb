Given("mailcatcher is not already running") do
  Coruro.new(adapter: :mailcatcher).stop
end

When("I instantiate Coruro with the mailcatcher adapter") do
  Coruro.new(adapter: :mailcatcher,
             adapter_config: { expose_streams: { stdout: $stdout, stderr: $stderr } })
end


Then("Coruro knows mailcatcher is up") do
  Coruro.new(adapter: :mailcatcher).adapter.up?
end
