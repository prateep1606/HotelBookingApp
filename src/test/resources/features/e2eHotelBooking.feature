Feature: End-to-End Hotel Booking Management

Background:
Given the base API url is "https://automationintesting.online"

###################################################
# END TO END BOOKING API
###################################################

@hotel-booking-end-to-end
Scenario Outline: End-to-end Successful hotel room booking creation, modification and cancellation
Then the system authenticates the user with status code "<login_status>" and message "<login_message>"
When the user checks room availability with check-in "<checkin>" and check-out "<checkout>"
Then the system responds with status code "<availability_status>" and message "<availability_message>"
When the user selects room type "<roomtype>" and verifies the price "<price>"
Then the system confirms the selection with status code "<room_status>" and message "<room_message>"
When the user reserves the room with details
| firstname   | lastname   | email   | phone       | depositpaid   |
| <firstname> | <lastname> | <email> | <phone>     | <depositpaid> |
Then the booking is created with status code "<create_status>" and message "<create_message>"
And the response body should contain the message "Booking created successfully"
When the user edits the booking with new details
| roomid   | firstname        | lastname        | depositpaid        | checkin        | checkout        |
| <roomid> | <edit_firstname> | <edit_lastname> | <edit_depositpaid> | <edit_checkin> | <edit_checkout> |
Then the booking is updated with status code "<update_status>" and message "<update_message>"
And the response body should contain the message "Booking updated successfully"
When the user cancels the booking
Then the booking is cancelled with status code "<cancel_status>" and message "<cancel_message>"
And the response body should contain the message "Booking cancelled successfully"

Examples:
# Positive Case 1
| checkin    | checkout   | roomtype | price | firstname | lastname | email                | phone       | depositpaid | roomid | edit_firstname | edit_lastname | edit_depositpaid | edit_checkin | edit_checkout| login_status | login_message       | availability_status | availability_message | room_status | room_message       | create_status | create_message       | update_status | update_message       | cancel_status | cancel_message       |
| 2026-03-10 | 2026-03-12 | Single   | 150   | Prat      | Teep1    | prat.teep1@mail.com  | 91234567890 | true        | 34     | Baby           | Jammy         | false            | 2026-03-11   | 2026-03-12   | 200          | Login successful    | 200                 | Rooms available      | 200         | Room selected      | 201           | Booking created      | 200           | Booking updated      | 200           | Booking cancelled    |
# Positive Case 2
| 2026-04-15 | 2026-04-18 | Double   | 250   | PSP       | Swats    | psp.swats@mail.com   | 99876543210 | false       | 35     | Maddy          | Diwan         | true             | 2026-04-16   | 2026-04-18   | 200          | Login successful    | 200                 | Rooms available      | 200         | Room selected      | 201           | Booking created      | 200           | Booking updated      | 200           | Booking cancelled    |
# Negative Case 1: Invalid email format
| 2026-05-01 | 2026-05-03 | Suite    | 400   | Pandi     | Nadar    | pandi.nadar@mail     | 9876543210  | true        | 36     | Prabhu         | Pandi         | false            | 2026-05-02   | 2026-05-03   | 200          | Login successful    | 200                 | Rooms available      | 200         | Room selected      | 400           | Invalid email format | 400           | Booking not updated  | 400           | Booking not cancelled|
# Negative Case 2: Checkout before checkin
| 2026-06-10 | 2026-06-08 | Single   | 150   | Prat      | Teep1    | prat.teep1@mail.com  | 9123000000  | true        | 37     | Agathi         | Yar           | false            | 2026-06-09   | 2026-06-10   | 200          | Login successful    | 400                 | Invalid date range   | 400         | Room not selected  | 400           | Booking not created  | 400           | Booking not updated  | 400           | Booking not cancelled|