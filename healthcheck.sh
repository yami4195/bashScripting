#!/bin/bash

URL="$1"

echo "Checking $URL"

WITH_OUT_PROTOCOL="${URL#*://}"
HOST="${WITH_OUT_PROTOCOL%%/*}"

echo "Url: $URL"
echo "Hostname:$HOST"

#DNS CHECK

IP=$(dig +short "$HOST" | head -n 1)

if [ -n "$IP" ]; then
echo "DNS: PASS - $IP"

else
echo "DNS: FAIL - could not resolve host name"
fi

#TCP CHECK

 if nc -z -w 5 "$HOST" 443 2>/dev/null; then
echo "TCP: PASS - Port 443 is reachable"
else
echo "TCP: FAIL - Port 443 is not reachable"
fi

#CERTIFICATE CHECK

EXPIRY=$(echo | openssl s_client -connect "$HOST:443" -servername "$HOST" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)

if [ -n "$EXPIRY" ]; then
    EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s)
    NOW_EPOCH=$(date +%s)

    DAYS_LEFT=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))

    if [ "$DAYS_LEFT" -lt 0 ]; then
        echo "TLS: FAIL - Certificate has expired"
    elif [ "$DAYS_LEFT" -lt 30 ]; then
        echo "TLS: WARNING - Certificate expires in $DAYS_LEFT days"
    else
        echo "TLS: PASS - Certificate expires in $DAYS_LEFT days"
    fi
else
    echo "TLS: FAIL - Could not retrieve certificate"
fi
