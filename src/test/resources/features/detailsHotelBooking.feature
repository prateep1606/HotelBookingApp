Feature: Hotel Booking Details Report

Background:
Given the base API url is "https://automationintesting.online"

###################################################
# DETAILS BOOKING API
###################################################

@verify-booking-report-details
Scenario: Get booking report details
Given the endpoint "/api/report"
When user sends GET request
Then response status code should be 200
And response should contain booking report data

@verify-valid-dates-room-availability
Scenario Outline: Check room availability with valid dates
Given the endpoint "/api/room"
When user sends GET request with checkin "<checkin>" and checkout "<checkout>"
Then response status code should be 200
And available rooms should be returned

Examples:
| checkin    | checkout   |
| 2025-07-17 | 2025-07-18 |
| 2025-08-01 | 2025-08-05 |

@verify-invalid-dates-room-availability
Scenario Outline: Check room availability with invalid dates
Given the endpoint "/api/room"
When user sends GET request with checkin "<checkin>" and checkout "<checkout>"
Then response status code should be 400

Examples:
| checkin    | checkout   |
| 2025-07-20 | 2025-07-18 |
|            | 2025-07-18 |

@verify-valid-roomid
Scenario Outline: Get room details using room id
Given the endpoint "/api/room/<roomid>"
When user sends GET request
Then response status code should be 200

Examples:
| roomid |
| 1      |
| 2      |
| 3      |

@verify-invalid-roomid
Scenario Outline: Validate room details for invalid room id
Given the endpoint "/api/room/<roomid>"
When user sends GET request
Then response status code should be "<status_code>"

Examples:
| roomid | status_code |
| 9@%99  | 404         |
| abc    | 400         |