Feature: Mailcatcher integration
  In order to not have to manage processes in my feature test suite
  As a developer
  I would like Coruro to manage the Mailcatcher process for me

  Scenario: Lazily starting coruro
    Given the mailcatcher adapter is not already running
    When I instantiate Coruro with the mailcatcher adapter
    Then Coruro knows the mailcatcher adapter is up
