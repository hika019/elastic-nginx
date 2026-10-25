
#!/bin/sh
set -eu

KIBANA_URL="http://kibana:5601"

echo "Waiting for Kibana..."

attempt=0
until curl -fsS --max-time 5 \
  "$KIBANA_URL/api/status" > /dev/null 2>&1
do
  attempt=$((attempt + 1))

  if [ "$attempt" -ge 120 ]; then
    echo "Kibana startup timeout"
    exit 1
  fi

  sleep 5
done

echo "Importing dashboards..."

response=$(curl -fsS \
  -X POST \
  -H "kbn-xsrf: true" \
  -F "file=@/config/dashboards.ndjson" \
  "$KIBANA_URL/api/saved_objects/_import?overwrite=true")

echo "$response"

if ! echo "$response" | grep -Eq \
  '"success"[[:space:]]*:[[:space:]]*true'
then
  echo "Dashboard import failed"
  exit 1
fi

echo "Dashboard import completed"
