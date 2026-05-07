#!/usr/bin/env bash
API_PROFILE_ENDPOINT="http://localhost:3000/api/"

# LOAD parameters
REQUEST_COUNT=1000
TIME_BETWEEN_REQUEST_SECONDS=1

# Platform requisites
EXPECTED_HTTP_CODE=200
ESTABLISH_CONNECTION_TIMEOUT_SECONDS=30
COMPLETE_REQUEST_TIMEOUT_SECONDS=60

# General purpose
EXECUTION_FAILED_RETURN_CODE=1
EXECUTION_SUCCESSFUL_RETURN_CODE=0

for (( i = 0; i <= REQUEST_COUNT; i++ ))
do

  ACTUAL_HTTP_CODE=$(curl --connect-timeout $ESTABLISH_CONNECTION_TIMEOUT_SECONDS --max-time $COMPLETE_REQUEST_TIMEOUT_SECONDS --silent --include -o /dev/null -w "%{http_code}" --request GET  "$API_PROFILE_ENDPOINT")

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
