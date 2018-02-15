Given("mailcatcher is not already running") do
  Coruro.new(adapter: :mailcatcher).stop
end

When("I instantiate Coruro with the mailcatcher adapter") do
  Coruro.new(adapter: :mailcatcher)
end


Then("Coruro knows mailcatcher is up") do
  Coruro.new(adapter: :mailcatcher).adapter.up?
end
