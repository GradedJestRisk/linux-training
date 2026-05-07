#!/usr/bin/env bash

# https://stackoverflow.com/questions/18215389/how-do-i-measure-request-and-response-times-at-once-using-curl

BASE_URL="http://localhost:1000"
ROUTE="users"
API_URL="$BASE_URL/$ROUTE"
JWT_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30"
VERB=POST

COUNTRY="england"
TIMES=5
export MESSAGE="%{http_code} - %{time_total}\n"

echo "About to send to $API_URL ($VERB) user creation from country $COUNTRY"
echo "Message format is : <Return code  - time elapsed (s)>"

for i in 1 2; do

  echo "Create $i user(s), $TIMES times"

  for j in $(seq $TIMES); do

    PAYLOAD_FILE="./dataset/$COUNTRY/$i.json"

    jq . $PAYLOAD_FILE | \
    curl \
       "$API_URL" \
      --write-out "$MESSAGE" \
      --request POST \
      --header 'Content-Type: application/json' \
      --header "Authorization: Bearer $JWT_TOKEN" \
      --data @- \
      --silent \
      --output /dev/null
  done

done

echo "Finished"