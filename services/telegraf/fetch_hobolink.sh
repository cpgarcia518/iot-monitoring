#!/bin/bash

# Set timestamps
END_TIME=$(date -u +"%Y-%m-%d %%H:%%M:%%S")
START_TIME=$(date -u -d '-30 minutes' +"%Y-%m-%d %%H:%%M:%%S")

START="${START_DATE_TIME:-$START_TIME}"
END="${END_DATE_TIME:-$END_TIME}"

# URL encode time
START_ENCODED=$(echo $START | sed 's/ /%20/g')
END_ENCODED=$(echo $END | sed 's/ /%20/g')

# Default logger or from env
LOGGER_ID="${HOBO_LOGGER_ID:-21039797}"

# Construct URL
URL="${HOBO_API_URL:-https://api.hobolink.licor.cloud}/${HOBO_API_VERSION:-v1}/data?loggers=${LOGGER_ID}&start_date_time=${START_ENCODED}&end_date_time=${END_ENCODED}"

# Fetch the data
curl -s -H "Authorization: Bearer $HOBO_TOKEN" -H "Accept: application/json" "$URL"
# Check if the curl command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch data from HOBO API"
    exit 1
fi
# Check if the response is empty
if [ -z "$response" ]; then
    echo "Error: No data received from HOBO API"
    exit 1
fi