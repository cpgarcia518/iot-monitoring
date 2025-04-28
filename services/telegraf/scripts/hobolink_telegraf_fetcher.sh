#!/bin/bash
set -euo pipefail

# Check dependencies
command -v curl >/dev/null 2>&1 || { echo "Error: curl is required but not installed"; exit 1; }
command -v date >/dev/null 2>&1 || { echo "Error: date command is missing"; exit 1; }

# Validate input
if [ $# -lt 1 ]; then
    echo "Usage: $0 <API_TOKEN> [START_DATE] [END_DATE]"
    echo "Example: $0 your_api_token_here '2025-04-28 09:11:20' '2025-04-28 09:26:20'"
    echo "Note: START_DATE and END_DATE are optional. If not provided, the script will use the last 15 minutes as the default time range."
    exit 1
fi

# Calculate time ranges
# end_date=$(date -u +"%Y-%m-%d %H:%M:%S")
end_date=${3:-$(date -u +"%Y-%m-%d %H:%M:%S")}
# start_date=$(date -u -d "15 minutes ago" +"%Y-%m-%d %H:%M:%S")
start_date=${2:-$(date -u -d "15 minutes ago" +"%Y-%m-%d %H:%M:%S")}
# Uncomment the following lines to set a custom time range
start_date="${START_DATE_TIME:-$start_date}"
end_date="${END_DATE_TIME:-$end_date}"
# start_date="2025-04-28 09:11:20"
# end_date="2025-04-28 09:26:20"

# URL-encode timestamps
url_start_date=$(echo "$start_date" | sed 's/ /%20/g; s/:/%3A/g')
url_end_date=$(echo "$end_date" | sed 's/ /%20/g; s/:/%3A/g')
# printf "Fetching data from %s to %s...\n" "$start_date" "$end_date"

# Default logger ID
logger_id="${HOBO_LOGGER_ID:-21039797}"
api_url="https://api.hobolink.licor.cloud/v1/data?loggers=${logger_id}&start_date_time=${url_start_date}&end_date_time=${url_end_date}"

# Fetch data from HOBO API
response=$(curl -s -X GET "$api_url" \
  -H "accept: application/json" \
  -H "Authorization: Bearer $1")
# Check for errors
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch data from HOBO API"
    exit 1
fi
# Check for empty response
if [ -z "$response" ]; then
    echo "Error: No data received from HOBO API"
    exit 1
fi
# Print the response
# echo "$response"

# Transform to Influx Line Protocol
echo "$response" | jq -r '
.data[] | 
"\(.sensor_measurement_type | gsub(" "; "_") | ascii_downcase),logger_sn=\(.logger_sn),sensor_sn=\(.sensor_sn),unit=\(.unit) value=\(.value) \(
    (.timestamp | sub(" "; "T") | sub("Z"; "")) | 
    strptime("%Y-%m-%dT%H:%M:%S") | 
    mktime | . * 1000000000
)"
'