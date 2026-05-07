#!/usr/bin/env bash
# https://stackoverflow.com/questions/18611903/how-to-pass-payload-via-json-file-for-curl

BASE_URL="http://localhost:1000"
ROUTE="user"
API_URL="$BASE_URL/$ROUTE"
JWT_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30"

VERB=POST
PAYLOAD_FILE=./1.json

echo "About to send to $API_URL ($VERB), the payload below"
jq . $PAYLOAD_FILE

echo "Sending..."

USER_IDENTIFIER=$(
  jq . $PAYLOAD_FILE | \
  curl \
     "$API_URL" \
    --request $VERB \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $JWT_TOKEN" \
    --data @- \
    --silent | \
  jq '.id'  --raw-output
)

echo "Successfully sent"

echo "User $USER_IDENTIFIER has been created"