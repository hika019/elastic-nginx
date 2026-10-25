
#!/bin/sh
set -eu

ES_URL="${ES_URL:-http://es:9200}"
CONFIG_DIR="/config"

put_config() {
    name="$1"
    endpoint="$2"
    file="$3"

    echo "Installing ${name}..."

    response=$(curl -fsS \
        --retry 5 \
        --retry-delay 2 \
        -X PUT \
        -H "Content-Type: application/json" \
        --data-binary "@${CONFIG_DIR}/${file}" \
        "${ES_URL}/${endpoint}")

    echo "$response"

    if ! echo "$response" | grep -Eq \
        '"acknowledged"[[:space:]]*:[[:space:]]*true'; then
        echo "Failed to install ${name}" >&2
        exit 1
    fi
}

put_config \
    "ILM policy" \
    "_ilm/policy/filebeat" \
    "ilm-policy.json"

put_config \
    "GeoIP pipeline" \
    "_ingest/pipeline/nginx-geoip" \
    "geoip-pipeline.json"

put_config \
    "Index template" \
    "_index_template/nginx-log" \
    "index-template.json"

echo "Elasticsearch initialization completed."
