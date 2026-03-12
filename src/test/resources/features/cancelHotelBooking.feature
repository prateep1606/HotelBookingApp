Feature: Cancel Hotel Booking

  Background: 
    Given the base API url is "https://automationintesting.online"

  ###################################################
  # CANCEL BOOKING API
  ###################################################
  @cancel-valid-booking
  Scenario Outline: cancel booking with valid details
    Given user should book the hotel room with following details
      | firstname   | lastname   | email   | phone   | checkin   | checkout   | depositpaid   |
      | <firstname> | <lastname> | <email> | <phone> | <checkin> | <checkout> | <depositpaid> |
    Then user should submit the hotel booking request
    And user should receive the hotel room booking id
    When user should cancel the booking
    Then booking should be cancelled with status 200
    And response should contain "Booking cancelled successfully"

    Examples: 
      | firstname | lastname | email       | phone       | checkin    | checkout   | depositpaid |
      | Prateep   | PSPB     | new@abc.com | 87234765471 | 11-03-2026 | 12-03-2026 | true        |

  Scenario Outline: cancel booking with invalid details
    Given user should book the hotel room with following valid details
      | firstname | lastname | email       | phone       | checkin    | checkout   | depositpaid |
      | Prateep   | PSPB     | new@abc.com | 87234765471 | 11-03-2026 | 12-03-2026 | true        |
    Then user should submit the hotel booking request
    And user should receive the hotel room booking id
    When user should attempt to cancel the booking with booking id "<bookingId>"
    Then booking cancellation should fail with status <statusCode> and "<errorMessage>"
    And the API response should match the response code

    Examples: 
      # Invalid booking ID
      | bookingId | statusCode | errorMessage                 |
      |           |        400 | Booking ID must not be blank |
      | abc       |        400 | Booking ID must be numeric   |
      |     99999 |        404 | Booking not found            |
      # Already cancelled booking
      | bookingId | statusCode | errorMessage                 |
      |       101 |        404 | Booking not found    				|
      # Unauthorized cancellation
      | bookingId | statusCode | errorMessage                 |
      |       101 |        403 | Permission Denied          	|

  @verify-cancellation-past-deadline
  Scenario: verify cancellation attempt for a booking past the cancellation deadline
    Given user should book the hotel room with following details
      | firstname   | lastname   | email   | phone   | checkin   | checkout   | depositpaid   |
      | <firstname> | <lastname> | <email> | <phone> | <checkin> | <checkout> | <depositpaid> |
    Then user should submit the hotel booking request
    And user should receive the hotel room booking id
    When user should attempt to cancel the booking with booking id
    Then the user sends request past the free cancellation deadline booking ID "<booking_id>"
    And the response body should contain the error message 404