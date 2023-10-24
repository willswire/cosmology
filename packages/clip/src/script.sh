#!/bin/bash

# Check if the required environment variables are set
if [[ -z "$ZONE_ID" ]] || [[ -z "$AUTH_KEY" ]]; then
    echo "Error: ZONE_ID and AUTH_KEY must be set."
    exit 1
fi

# Function to update or create DNS record
update_or_create_dns_record() {
    local ip="$1"
    local name="$2"

    # Check if the DNS record exists and retrieve its ID if it does
    local record_id
    record_id=$(curl -s \
        --request GET \
        --url "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$name&type=A" \
        --header "Authorization: Bearer $AUTH_KEY" \
        --header 'Content-Type: application/json' | jq -r '.result[0].id')

    local data
    data=$(jq -nc --arg ip "$ip" --arg name "$name" '{
        content: $ip,
        name: $name,
        proxied: true,
        type: "A",
        comment: ("Cosmology Update: " + (now | strftime("%Y-%m-%d %H:%M:%S")))
    }')

    # If the DNS record exists, update it. Otherwise, create a new one.
    if [[ "$record_id" != "null" ]]; then
        curl --no-progress-meter \
            --request PUT \
            --url "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$record_id" \
            --header 'Content-Type: application/json' \
            --header "Authorization: Bearer $AUTH_KEY" \
            --data "$data"
    else
        curl --no-progress-meter \
            --request POST \
            --url "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
            --header 'Content-Type: application/json' \
            --header "Authorization: Bearer $AUTH_KEY" \
            --data "$data"
    fi
}

# Main loop
while true; do
    ip=$(kubectl get service/public-ingressgateway -n istio-system -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
    
    if [[ -z "$ip" ]]; then
        echo "Failed to retrieve IP. Retrying after 60 seconds..."
        sleep 60
        continue
    fi

    update_or_create_dns_record "$ip" "tatooine.dev"
    update_or_create_dns_record "$ip" "*.tatooine.dev"

    echo "Cosmology Update: $(date)"

    sleep 600
done
