#!/bin/bash

# Define the API URL
URL="https://api.winlink.org/channel/add"

# Define the JSON payload
JSON_PAYLOAD='{
  "Callsign": "K1YMI-10",
  "BaseCallsign": "K1YMI",
  "GridSquare": "FN23NB",
  "Frequency": 145070000,
  "Mode": "PKT",
  "Baud": 1200,
  "Power": 25,
  "Height": 0,
  "Gain": 0,
  "Direction": 0,
  "Hours": "00-23",
  "ServiceCode": "PUBLIC",
  "Key": "<API_KEY>"
}'

# Get the length of the JSON payload
CONTENT_LENGTH=$(echo -n "$JSON_PAYLOAD" | wc -c)

# Function to provide diagnostic feedback
function diagnostic_feedback {
  echo "Diagnostics:"
  echo "---------------------------------"
  echo "URL: $URL"
  echo "JSON Payload: $JSON_PAYLOAD"
  echo "Content Length: $CONTENT_LENGTH"
  echo "---------------------------------"
}

# Display diagnostics before making the request
diagnostic_feedback

# Send the HTTPS POST request using curl
RESPONSE=$(curl -s -o response.txt -w "%{http_code}" -X POST "$URL" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD")

# Capture the HTTP response code and response body
HTTP_CODE=$RESPONSE
RESPONSE_BODY=$(cat response.txt)

# Display the response and diagnostics
echo "Response Code: $HTTP_CODE"
echo "Response Body: $RESPONSE_BODY"

# Check the HTTP response code for success or failure
if [[ "$HTTP_CODE" -ge 200 && "$HTTP_CODE" -lt 300 ]]; then
  echo "Request succeeded with HTTP code $HTTP_CODE."
elif [[ "$HTTP_CODE" -ge 400 && "$HTTP_CODE" -lt 500 ]]; then
  echo "Client error occurred with HTTP code $HTTP_CODE."
elif [[ "$HTTP_CODE" -ge 500 ]]; then
  echo "Server error occurred with HTTP code $HTTP_CODE."
else
  echo "Unexpected response code: $HTTP_CODE."
fi
