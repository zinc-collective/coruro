Feature: Custom adapters
  In order to be able to leverage adapters the Coruro team hasn't considered
  As a developer
  I would like Coruro to let me define custom adapters


  Scenario: Starting a custom adapter
    Given the custom adapter is not already running
    When I instantiate Coruro with the custom adapter
    Then Coruro knows the custom adapter is up


  Scenario: Ending a custom adapter
    Given Coruro has started the custom adapter
    When I stop Coruro with the custom adapter
    Then Coruro knows the custom adapter is not up

