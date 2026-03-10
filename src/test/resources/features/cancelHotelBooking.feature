Feature: Cancel Hotel Booking

Background:
Given the base API url is "https://automationintesting.online"

###################################################
# CANCEL BOOKING API
###################################################

@verify-booking-cancellation
Scenario Outline: verify booking cancellation
Given user with a valid API key and "<booking_status>" booking reference
When the user sends a cancellation request for booking ID "<booking_id>"
Then the API response status code should be "<status_code>"
 And the response body should contain the message "<expected_message>"

Examples:
| booking_id |booking_status    |status_code|expected_message               |
| B12345     |confirmed         |200        |Booking cancelled successfully |
| B67890     |already cancelled |400        |Invalid Booking ID             |
| B54321     |past stay         |400        |Invalid Booking ID             |
|            |empty             |400        |Invalid Booking ID             |
| B22334     |unauthorized user |403        |Permission Denied              |
| B00000     |non-existent      |404        |Booking not found              |

@verify-cancellation-past-deadline
Scenario Outline: verify cancellation attempt for a booking past the cancellation deadline
Given user with a valid API key and a "<booking_status>" booking with ID "<booking_id>"
And the current date is past the free cancellation deadline
When the user sends a cancellation request for booking ID "<booking_id>"
Then the API response status code should be "<status_code>"
And the response body should contain the error message "Invalid Booking ID"

Examples:
| booking_id |booking_status    |status_code|
| B12345     |confirmed         |400        |

@verify-free-cancellation
Scenario: verify cancellation attempt for a booking within the free cancellation period
Given user with a valid API key and a booking ID "<booking_id>" with the future date
When the user sends a cancellation request for booking status "<booking_status>"
Then the API response status code should be "<status_code>"
And the response body should contain the message "Booking cancelled successfully"

Examples:
| booking_id |booking_status    |status_code|
| B12345     |confirmed         |200        |