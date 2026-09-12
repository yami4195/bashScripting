#!/bin/bash

URL="$1"

echo "Checking $URL"

WITH_OUT_PROTOCOL="${URL#*://}"
HOST="${WITH_OUT_PROTOCOL%%/*}"

echo "Url: $URL"
echo "Hostname:$HOST"

#DNS check

IP=$(dig +short "$HOST" | head -n 1)

if [ -n "$IP" ]; then
echo "DNS: PASS - $IP"

else
echo "DNS: FAIL - could not resolve host name"
fi
