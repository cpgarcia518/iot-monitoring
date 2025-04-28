#!/bin/bash
set -euo pipefail

# Check if correct number of arguments
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <API_TOKEN> <START_DATE_TIME> <END_DATE_TIME>"
  echo "Example: $0 YOUR_API_TOKEN \"2025-04-28 08:00:00\" \"2025-04-28 09:00:00\""
  exit 1
fi

API_TOKEN="$1"
START_DATE_TIME="$2"
END_DATE_TIME="$3"

# Export the start and end time so the fetcher script can pick them up
export START_DATE_TIME
export END_DATE_TIME

# Run the fetcher and pipe to telegraf
./hobolink_telegraf_fetcher.sh "$API_TOKEN" | \
  telegraf --config /dev/stdin \
  --input-filter exec \
  --once \
  --output-filter influxdb_v2
