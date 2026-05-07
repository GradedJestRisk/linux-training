#!/usr/bin/env bash

# API Endpoints
API_TOKEN_ENDPOINT="http://localhost:3000/api/token"
API_TOKEN_REQUEST_BODY="grant_type=password&username=sco.admin%40example.net&password=pix123&scope=pix-orga"

# API Endpoints - Under test
API_PROFILE_ENDPOINT="http://localhost:3000/api/users/me"
API_XML_ENDPOINT="http://localhost:3000/api/organizations/3/schooling-registrations/import-siecle?format=xml"

# LOAD parameters
REQUEST_COUNT=100
TIME_BETWEEN_REQUEST_SECONDS=0.01
SEND_XML_ON_PART=4

# Platform requisites
EXPECTED_HTTP_CODE=200
ESTABLISH_CONNECTION_TIMEOUT_SECONDS=30
COMPLETE_REQUEST_TIMEOUT_SECONDS=60

# General purpose
EXECUTION_FAILED_RETURN_CODE=1
EXECUTION_SUCCESSFUL_RETURN_CODE=0

RESULT_NOT_ROUNDED=$((REQUEST_COUNT/SEND_XML_ON_PART))
SEND_XML_ON_ITERATION=$(echo $RESULT_NOT_ROUNDED | awk '{print int($RESULT_NOT_ROUNDED+0.5)}')

# Get token
curl --silent \
  --request POST  \
  --data $API_TOKEN_REQUEST_BODY \
  $API_TOKEN_ENDPOINT |  jq --raw-output .access_token > token.txt

# Build headers
echo -e "Authorization: Bearer $(cat token.txt)" > headers.txt

# Make synchronous request
#
# To turn asynchronous use, spawns child subprocesses  using for do ( if... ) & sleep done wait
# But in case a request fails, the subshell will exit and the parent will get not notice that something went wrong
# Children cannot communicate to the parent through variable
 # The easiest way to notice the parent the request went wrong is to use return code $?
# To collect them in the parent and check them after all children completed,
# => see https://unix.stackexchange.com/questions/344360/collect-exit-codes-of-parallel-background-processes-sub-shells
for (( i = 0; i <= REQUEST_COUNT; i++ ))
do

  if [ "$i" == "$SEND_XML_ON_ITERATION" ];  then
    SCHOOLING_ACTUAL_HTTP_CODE=$(curl --connect-timeout $ESTABLISH_CONNECTION_TIMEOUT_SECONDS --max-time $COMPLETE_REQUEST_TIMEOUT_SECONDS --silent --include -o /dev/null -w "%{http_code}" --header "@./headers.txt" --header 'Content-Type: application/xml' --data-binary "@./SIECLE.xml" --request POST "$API_XML_ENDPOINT")
    echo "$API_XML_ENDPOINT" returned "$SCHOOLING_ACTUAL_HTTP_CODE"
  fi

  ACTUAL_HTTP_CODE=$(curl --connect-timeout $ESTABLISH_CONNECTION_TIMEOUT_SECONDS --max-time $COMPLETE_REQUEST_TIMEOUT_SECONDS --silent --include -o /dev/null -w "%{http_code}" --header "@./headers.txt" --request GET  "$API_PROFILE_ENDPOINT")
  if [ "$ACTUAL_HTTP_CODE" != "$EXPECTED_HTTP_CODE" ]; then
      echo "$REQUEST_COUNT" requests were to be sent "$API_PROFILE_ENDPOINT"
      echo $i requests were successfully sent and completed with expected HTTP code "$EXPECTED_HTTP_CODE"
      echo 1 request completed with unexpected HTTP code "$ACTUAL_HTTP_CODE"
      echo exiting..
      exit $EXECUTION_FAILED_RETURN_CODE
  fi

	sleep "$TIME_BETWEEN_REQUEST_SECONDS"

done

echo "$REQUEST_COUNT" requests were to be sent "$API_ENDPOINT"
echo All of them were successfully sent and completed with expected HTTP code "$EXPECTED_HTTP_CODE"

exit $EXECUTION_SUCCESSFUL_RETURN_CODE
