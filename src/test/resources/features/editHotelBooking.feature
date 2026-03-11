Feature: Edit Hotel Booking

Background:
Given the base API url is "https://automationintesting.online"

###################################################
# EDIT BOOKING API
###################################################

@verify-edit-booking-valid-details
Scenario Outline: Successfully edit booking details with valid details
When user sends a PUT request to update the booking ID "<booking_id>" with new "<field>" and "<value>"
Then the API response status code should be "<status_code>"
And the response body should confirm the update with "<expected_message>"
And the response body should contain the updated booking details
And booking should be edited successfully

Examples:
booking_id  | field     | value           | status_code | expected_message             |
B12345      | firstname | NewFirstName    | 200         | Booking updated successfully |
B12345      | lastname  | NewLastName     | 200         | Booking updated successfully |
B12345      | phone     | 8723476547      | 200         | Booking updated successfully |
B12345      | email     | teep@abc.com    | 200         | Booking updated successfully |
B12345      | deposit   | true            | 200         | Booking updated successfully |

@edit-booking-invalid-missing-details
Scenario Outline: edit a booking with invalid or missing credentials
Given user an "<authentication_token_status>" authentication token
When user sends PUT request to update the booking "<booking_id>" with a valid new value
Then the API response status code should be "<status_code>"
And the response body should contain the error message "<error_message>"

Examples:
booking_id | authentication_token_status | status_code | error_message          |
B99999     | invalid                     | 401         | Unauthorized access    |
B12345     | empty                       | 404         | Authentication required|
B12345     | expired                     | 403         | Forbidden access       |

@validate-updating-non-existent-booking
Scenario: validate to update a non-existent booking
Given a valid authentication token is available
When user sends PUT request to update the non-existent booking "BK9999"
Then the API response status code should be 404
And the response body should contain the error message "Booking not found"

@validate-updating-past-check-in-date-booking
Scenario Outline: validate to update a booking with invalid data types
When I send a PUT request to update the booking "<booking_id>" with "<field>" and invalid "<value>"
Then the API response status code should be "<status_code>"
And the response body should contain the error message "<error_message>"

Examples:
booking_id  | field        | value           | status_code | error_message   |
B12345      | totalprice   | "invalid_price" | 400         | Amount mismatch |
B01234      | checkin      | "yesterday"     | 400         | Invalid date    |

@validate-edit-using-invalid-token
Scenario: validate to edit a booking without a valid authentication token
Given user with no authentication token is provided
And the request details are for booking ID "B12345"
When the user sends the PUT request to edit the booking
Then the response status code should be 401 Unauthorized

@validate-edit-booking-with-invalid-checkin-checkout-dates
Scenario Outline: validate to edit a booking with a check-out date before the check-in date
Given the request details are for booking ID "<booking_id>"
And the request body contains invalid booking dates checkin "<checkin>" and checkout "<checkout>" dates
When the user sends the PUT request to edit the booking
Then the response status code should be "<status_code>" Bad Request
And the response body should contain a business logic error message

Examples:
|booking_id  |checkin    |checkout   |status_code |
|B12345      |11-03-2026 |10-03-2026 |400         |