#!/bin/bash

API_KEY="<YOUR_APIKEY>"
DOMAIN="<example.com>"
#If you need to add TXT record to the subdomain sub.example.com, append .sub
#SUBDOMAIN="_acme-challenge.sub"
SUBDOMAIN="_acme-challenge"

# Remove a DNS TXT record
remove_txt_record() {
    RECORD_ID=$(curl -s \
                "https://www.namesilo.com/api/dnsListRecords?version=1&key=$API_KEY&type=json&domain=$DOMAIN" \
                | jq -r ".reply.resource_record.[] | select(.host==\"$SUBDOMAIN.$DOMAIN\").record_id")

    if [ -n "$RECORD_ID" ]; then
        curl -s "https://www.namesilo.com/api/dnsDeleteRecord?version=1&key=$API_KEY&type=xml&domain=$DOMAIN&rrid=$RECORD_ID" \
             && echo "Successfully removed TXT record with ID $RECORD_ID"
    else
        echo "Record ID not found for $SUBDOMAIN.$DOMAIN; nothing to remove."
    fi
}

remove_txt_record
