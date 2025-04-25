#!/usr/bin/env bash
set -e

# — your API token —
HOBOLINK_TOKEN="00JPWRvRJ9hn1qVqeIdE149iTFfjG425EFsUFXSMjvSXltp5"

# — usage check —
if [ $# -ne 1 ]; then
  echo "Usage: $0 \"YYYY-MM-DD HH:MM:SS\""
  exit 1
fi

START_RAW="$1"

# — turn START_RAW into Unix seconds —
if date --version >/dev/null 2>&1; then
  # GNU date
  START_SEC=$(date -d "$START_RAW" +%s)
else
  # BSD/macOS date
  START_SEC=$(date -j -f '%Y-%m-%d %H:%M:%S' "$START_RAW" +%s)
fi

# — add 10 minutes →
END_SEC=$((START_SEC + 600))

# — turn back into YYYY-MM-DD HH:MM:SS —
if date --version >/dev/null 2>&1; then
  END_RAW=$(date -d "@$END_SEC" '+%Y-%m-%d %H:%M:%S')
else
  END_RAW=$(date -r "$END_SEC" '+%Y-%m-%d %H:%M:%S')
fi

# — URL-encode (space → %20, colon → %3A) —
encode() {
  printf '%s' "$1" | sed -e 's/ /%20/g' -e 's/:/%3A/g'
}

START_ENC=$(encode "$START_RAW")
END_ENC=$(encode "$END_RAW")

echo "Fetching from $START_RAW to $END_RAW …"

# — run curl —
curl -s -X GET \
  "https://api.hobolink.licor.cloud/v1/data?loggers=21039797&start_date_time=${START_ENC}&end_date_time=${END_ENC}" \
  -H "accept: application/json" \
  -H "Authorization: Bearer ${HOBOLINK_TOKEN}"

# — check for errors —
if [ $? -ne 0 ]; then
  echo "Error: Failed to fetch data from HOBO API"
  exit 1
fi
# — check for empty response —
if [ -z "$response" ]; then
  echo "Error: No data received from HOBO API"
  exit 1
fi