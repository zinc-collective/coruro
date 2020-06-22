Feature: Mailcatcher integration
  In order to not have to manage processes in my feature test suite
  As a developer
  I would like Coruro to manage the Mailcatcher process for me

  Scenario: Starting mailcatcher if it is not running already
    Given the mailcatcher adapter is not already running
    When I instantiate Coruro with the mailcatcher adapter
    Then Coruro knows the mailcatcher adapter is up

  Scenario: Bypass starting mailcatcher when it is already running
    Given the mailcatcher adapter is not already running
    When the mailcatcher adapter is configured for a remote server
    Then Coruro knows the mailcatcher adapter is up
    And Coruro did not start a mailcatcher process