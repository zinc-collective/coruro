Feature: Mailcatcher integration
  In order for life to be easy and wonderful
  As a developer
  I would like coruro to manage the Mailcatcher process for me

  Scenario: Lazily starting coruro
    Given mailcatcher is not already running
    When I instantiate Coruro with the mailcatcher adapter
    Then Coruro knows mailcatcher is up
