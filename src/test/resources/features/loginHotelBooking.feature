Feature: Login Hotel Booking - User Authentication

Background:
Given the base API url is "https://automationintesting.online"

###################################################
# LOGIN BOOKING API
###################################################

@login-valid-admin-credentials
Scenario: Login with valid admin credentials
Given the endpoint "/api/auth/login"
When user sends POST request with username "admin" and password "password"
Then response status code should be 200
And auth token should be returned

@login-invalid-admin-credentials
Scenario Outline: Login with invalid credentials
Given the endpoint "/api/auth/login"
When user sends POST request with username "<username>" and password "<password>"
Then the API response status code should be "<status_code>"
And the response body should contain "<message>"

Examples:
|username |password  |status_code |message                     |
|admin    |wrongpass |401         |Invalid username or password|
|wronguser|password  |401         |Invalid username or password|

@login-using-empty-credentials
Scenario Outline: Login using empty credentials
Given the endpoint "/api/auth/login"
When user sends POST request with username "<username>" and password "<password>"
Then the API response status code should be "<status_code>"
And the response body should contain "<message>"

Examples:
|username |password  |status_code |message                             |
|admin    |          |400         |Username or password cannot be empty|
|         |password  |400         |Username or password cannot be empty|
|         |          |400         |Username or password cannot be empty|

@login-using-locked-credentials
Given the endpoint "/api/auth/login"
When user sends POST request with locked username "admin" and password "password"
Then response status code should be 403
And the response body should contain error message