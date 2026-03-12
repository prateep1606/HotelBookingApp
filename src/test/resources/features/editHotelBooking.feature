Feature: Edit Hotel Booking

  Background: 
    Given the base API url is "https://automationintesting.online"

  ###################################################
  # EDIT BOOKING API
  ###################################################
  @update-booking-with-valid-details
  Scenario Outline: Successfully update booking with valid details
    Given user should book the hotel room with following details
      | firstname   | lastname   | email   | phone   | checkin   | checkout   | depositpaid   |
      | <firstname> | <lastname> | <email> | <phone> | <checkin> | <checkout> | <depositpaid> |
    Then user should submit the hotel booking request
    And user should receive the hotel room booking id
    When user should update the hotel room with following details
      | firstname        | lastname        | email        | phone        | checkin        | checkout        | depositpaid    |
      | <edit_firstname> | <edit_lastname> | <edit_email> | <edit_phone> | <edit_checkin> | <edit_checkout> | <edit_deposit> |
    Then user should update the booking request
    And booking should be edited with status 200

    Examples: 
      | firstname | lastname | email       | phone       | checkin    | checkout   | depositpaid | edit_firstname | edit_lastname | edit_email     | edit_phone   | edit_checkin | edit_checkout | edit_deposit |
      | Prateep   | PSPB     | new@abc.com | 87234765471 | 11-03-2026 | 12-03-2026 | true        | Test           | Raj           | edited@abc.com | 872347654712 | 12-03-2026   | 14-03-2026    | false        |

  @validate-booking-with-invalid-details
  Scenario Outline: Update booking with invalid details
    Given user should book the hotel room with following valid details
      | firstname | lastname | email       | phone       | checkin    | checkout   |
      | Prateep   | PSPB     | new@abc.com | 87234765471 | 11-03-2026 | 12-03-2026 |
    Then user should submit the hotel booking request
    And user should receive the hotel room booking id
    When user should update the hotel room with following details
      | firstname        | lastname        | email        | phone        | checkin        | checkout        |
      | <edit_firstname> | <edit_lastname> | <edit_email> | <edit_phone> | <edit_checkin> | <edit_checkout> |
    Then user should update the booking request
    And booking update should fail with status <statusCode> and "<errorMessage>"

    Examples: 
      # Firstname validation
      | edit_firstname | edit_lastname | edit_email     | edit_phone   | edit_checkin | edit_checkout | statusCode | errorMessage                        |
      |                | Raj           | edited@abc.com | 872347654712 | 12-03-2026   | 14-03-2026    |        400 | Firstname should not be blank       |
      | Si             | Raj           | edited@abc.com | 872347654712 | 12-03-2026   | 14-03-2026    |        400 | size must be between 3 and 18       |
      # Lastname validation
      | edit_firstname | edit_lastname | edit_email     | edit_phone   | edit_checkin | edit_checkout | statusCode | errorMessage                        |
      | Test           |               | edited@abc.com | 872347654712 | 12-03-2026   | 14-03-2026    |        400 | Lastname should not be blank        |
      | Test           | La            | edited@abc.com | 872347654712 | 12-03-2026   | 14-03-2026    |        400 | size must be between 3 and 30       |
      # Email validation
      | edit_firstname | edit_lastname | edit_email     | edit_phone   | edit_checkin | edit_checkout | statusCode | errorMessage                        |
      | Test           | Raj           | test           | 872347654712 | 12-03-2026   | 14-03-2026    |        400 | must be a well-formed email address |
      | Test           | Raj           | @gmail.com     | 872347654712 | 12-03-2026   | 14-03-2026    |        400 | must be a well-formed email address |
      # Phone validation
      | edit_firstname | edit_lastname | edit_email     | edit_phone   | edit_checkin | edit_checkout | statusCode | errorMessage                        |
      | Test           | Raj           | edited@abc.com |        87955 | 12-03-2026   | 14-03-2026    |        400 | size must be between 11 and 21      |
      # Date validation
      | edit_firstname | edit_lastname | edit_email     | edit_phone   | edit_checkin | edit_checkout | statusCode | errorMessage                        |
      | Test           | Raj           | edited@abc.com | 872347654712 |              | 14-03-2026    |        400 | must not be null                    |
      | Test           | Raj           | edited@abc.com | 872347654712 | 12-03-2026   |               |        400 | must not be null                    |
      | Test           | Raj           | edited@abc.com | 872347654712 | 32-03-2026   | 14-03-2026    |        400 | Failed to update booking            |
			| Test           | Raj           | edited@abc.com | 872347654712 | 12-03-2026   | 14-03-2026    |        400 | Failed to update booking            |
			
      @validate-updating-non-existent-booking
      Scenario: validate to update a non-existent booking
      Given user should update the hotel room with following details
      | firstname | lastname | email          | phone        | checkin    | checkout   | depositpaid |
      | Prateep   | PSPB     | teep12@abc.com | 872347654712 | 2026-03-12 | 2026-03-13 | true        |
      When user should update the booking request with invalid booking id
      Then the API response status code should be 404
      And the response body should contain the error message "Booking not found"
      
      @validate-edit-using-invalid-token
      Scenario: validate to edit a booking without a valid authentication token
      Given user with no authentication token is provided
      When the user sends the PUT request to edit the booking
      And the response status code should be 401 Unauthorized