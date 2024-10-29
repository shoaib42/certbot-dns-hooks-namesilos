#!/bin/bash

API_KEY="<YOUR_APIKEY>"
DOMAIN="<example.com>"
#If you need to add TXT record to the subdomain sub.example.com, append .sub
#SUBDOMAIN="_acme-challenge.sub"
SUBDOMAIN="_acme-challenge"

SLEEP_INTERVAL=30
INITIAL_WAIT=60

# Add a DNS TXT record
add_txt_record() {
    echo "Adding record with value $CERTBOT_VALIDATION"
    curl -s "https://www.namesilo.com/api/dnsAddRecord?version=1&type=xml&key=$API_KEY&domain=$DOMAIN&rrtype=TXT&rrhost=$SUBDOMAIN&rrvalue=$CERTBOT_VALIDATION&rrttl=3600"
}

# Check if the DNS record exists and matches the validation value
check_dns_propagation() {
    TXT_RECORD=$(dig +short TXT "${SUBDOMAIN}.${DOMAIN}" | grep -o "$CERTBOT_VALIDATION")
    if [[ "$TXT_RECORD" == "$CERTBOT_VALIDATION" ]]; then
        echo "DNS record verified!"
        return 0
    else
        echo "DNS record not yet propagated. Retrying in ${SLEEP_INTERVAL} seconds..."
        return 1
    fi
}

add_txt_record
echo "Waiting ${INITIAL_WAIT} seconds for DNS to propagate..."
sleep "$INITIAL_WAIT"

# Poll every minute until the DNS record propagates
while ! check_dns_propagation; do
    sleep "$SLEEP_INTERVAL"
done
