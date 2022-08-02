Feature: in this feature file, daily_cost sceniaros is covered 

  Scenario: Get daily costs.
    When sending a valid time period 
    And a list of time interval and cost pairs
    Then should get a list of daily costs

  Scenario: Get error for providing an invalid start date.
    When sending an invalid start date 
    And a list of time interval and cost pairs
    Then should get an error saying "invalid start date" 

  Scenario: Get error for providing an invalid end date.
    When sending an invalid end date
    And a list of time interval and cost pairs
    Then should get an error saying "invalid end date" 

  Scenario: Get error for providing an end date earlier than the start date.
    When sending an earlier end date
    And a list of time interval and cost pairs
    Then should get an error saying "start date must be eariler than the end date" 

  Scenario: Get error for providing an invalid time period.
    When sending a valid time period 
    And a list of invalid time interval and cost pairs
    Then should get an error saying "invalid time period" 

  Scenario: Get error for providing a non decimal cost.
    When sending a valid time period 
    And a list of time interval and invalid cost pairs
    Then should get an error saying "invalid cost"

  Scenario: Get error for providing a non positive cost.
    When sending a valid time period 
    And a list of time interval and negative cost pairs
    Then should get an error saying "cost should be a positive decimal"