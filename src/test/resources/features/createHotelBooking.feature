Feature: Create Hotel Booking 

Background:
Given the base API url is "https://automationintesting.online"

###################################################
# CREATE BOOKING API
###################################################

@create-valid-booking
Scenario outline: create booking with valid details
Given user gives checkin date as "<checkin>" and checkout date as "<checkout>"
When user sets a valid roomid "<roomid>"
And user tries to create a booking
| firstname   | lastname   | email   | phone   | depositpaid   |
| <firstname> | <lastname> | <email> | <phone> | <depositpaid> |
And the user should submit the booking
When user sends POST request with mandatory booking details
Then response status code should be 201
And the booking should be created successfully

Examples:
|roomid |checkin     |checkout    |firstname    |lastname    |email         |phone       |depositpaid  |
|1      | 2026-03-10 | 2026-03-12 | Prateep     | Paulraj    | teep@abc.com | 8723476547 | false       |
|2      | 2026-04-15 | 2026-04-18 | Paulraj     | Prateep    | raj@mail.com | 8723476548 | true        |

@validate-booking-firstname
Scenario outline: Validate booking with firstname
Given the booking API endpoint "/api/booking"
And the user provides valid booking details except firstname:
|roomid |checkin     |checkout    |lastname    |email         |phone       |depositpaid  |
|1      | 2026-03-10 | 2026-03-12 |Paulraj     | teep@abc.com | 8723476547 | false       |
When the user sends POST request with "<firstname>"
Then the API should respond with status code "<status_code>"
And the response body should contain the message "<expected_message>"

Examples:
| firstname                      | status_code | expected_message                |
| ab                             | 400         | size must be between 3 and 18   |
| bcdabcdabcdabcdabcdabcdabcdabcd| 400         | size must be between 3 and 18   |
| !@%*&^                         | 400         | must be a well-formed firstname |
|                                | 400         | Firstname should not be blank   |
| Testing                        | 201         | Booking created successfully    |

@validate-booking-lastname
Scenario: validate booking with lastname
Given the booking API endpoint "/api/booking"
And the user provides valid booking details except lastname:
|roomid |checkin     |checkout    |firstname  |email         |phone       |depositpaid  |
|1      | 2026-03-10 | 2026-03-12 |Prateep    | teep@abc.com | 8723476547 | false       |
When the user sends POST request with "<lastname>"
Then the API should respond with status code "<status_code>"
And the response body should contain the message "<expected_message>"

Examples:
| lastname                       | status_code | expected_message               |
| ab                             | 400         | size must be between 3 and 30  |
| bcdabcdabcdabcdabcdabcdabcdabcd| 400         | size must be between 3 and 30  |
| !@%*&^                         | 400         | must be a well-formed firstname|
|                                | 400         | Lastname should not be blank   |
| Testing                        | 201         | Booking created successfully   |

@validate-booking-phone-number
Scenario: validate booking with phone number
Given the endpoint "/api/booking"
And the user provides valid booking details except phone number:
|roomid |checkin     |checkout    |firstname  |lastname  |email        |depositpaid  |
|1      | 2026-03-10 | 2026-03-12 |Prateep    |Paulraj   |teep@abc.com | false       |
When user sends POST request with invalid "<phone_number>"
Then the API should respond with status code "<status_code>"
And the response body should contain the message "<expected_message>"

Examples:
| phone_number | status_code | expected_message               |
| 12345        | 400         | size must be between 11 and 21 |
| 12345abcde   | 400         | size must be between 11 and 21 |
| 12345678*#   | 400         | 12345678*#                     |
|              | 400         | must not be empty              |
| null         | 400         | size must be between 11 and 21 |
| 12345678900  | 201         | Booking created successfully   |

@validate-booking-email
Scenario: validate booking with email
Given the endpoint "/api/booking"
And the user provides valid booking details except email:
|roomid |checkin     |checkout    |firstname  |lastname  |phone        |depositpaid  |
|1      | 2026-03-10 | 2026-03-12 |Prateep    |Paulraj   |8723476547   | false       |
When user sends POST request with invalid "<email>"
Then the API should respond with status code "<status_code>"
And the response body should contain the message "<expected_message>"

Examples:
| email                    | status_code | expected_message                    |
| missing_at.com           | 400         | must be a well-formed email address |
| @missingdomain.com       | 400         | must be a well-formed email address |
| username@.com   		     | 400         | must be a well-formed email address |
| example.email.com        | 400         | must be a well-formed email address |
| example@example@email.com| 400         | must be a well-formed email address |
| valid@example.com        | 201         | Booking created successfully        |

@validate-invalid-checkin-checkout-dates
Scenario Outline: validate a booking by giving incorrect checkout date and check in date
Given user initiates to create a booking
When user gives checkin date as "<checkin>" and checkout date as "<checkout>"
And user submits the booking to verify
Then the API should respond with status code "<status_code>"
Then the user gets "<expected_message>" error message
And user should not be able to create a booking

Examples:
|checkin    |checkout   |status_code |expected_message                 |depositpaid |
|2026-03-10 |2026-02-08 |400         |Incorrect booking dates selected |true        |

@verify-valid-dates-room_availability
Scenario Outline: Check room availability with valid dates
Given the endpoint "/api/room"
When user sends GET request with checkin "<checkin>" and checkout "<checkout>"
Then response status code should be "<status_code>"
And available rooms should be returned

Examples:
|checkin    |checkout   |status_code |
|2026-03-10 |2026-03-11 |200         |
|2026-03-10 |2026-03-15 |200         |

@verify-invalid-dates-room-availability
Scenario Outline: Check room availability with invalid dates
Given the endpoint "/api/room"
When user sends GET request with checkin "<checkin>" and checkout "<checkout>"
Then response status code should be "<status_code>"
And user should not be able to proceed with booking

Examples:
|checkin    |checkout   |status_code |
|2026-03-11 |2026-03-10 |400         |
|2026-03-15 |2025-03-10 |400         |
