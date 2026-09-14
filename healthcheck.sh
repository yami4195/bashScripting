#!/bin/bash

URL="$1"

LOG_FILE="healthcheck.log"

FAILED=0

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

log() {
echo  "$1" | tee -a "$LOG_FILE" 
}


log "[$TIMESTAMP] Checking: $URL"

WITH_OUT_PROTOCOL="${URL#*://}"

HOST="${WITH_OUT_PROTOCOL%%/*}"

log "Url: $URL"

log "Hostname:$HOST"

#DNS CHECK

IP=$(dig +short "$HOST" | head -n 1)

if [ -n "$IP" ]; then
log "DNS: PASS - $IP"

else
log "DNS: FAIL - could not resolve host name"
FAILED=1
fi

#TCP CHECK

 if nc -z -w 5 "$HOST" 443 2>/dev/null; then
log "TCP: PASS - Port 443 is reachable"
else
log "TCP: FAIL - Port 443 is not reachable"
 FAILED=1
fi

#CERTIFICATE CHECK

EXPIRY=$(echo | openssl s_client -connect "$HOST:443" -servername "$HOST" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)

if [ -n "$EXPIRY" ]; then
    EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s)
    NOW_EPOCH=$(date +%s)

    DAYS_LEFT=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))

    if [ "$DAYS_LEFT" -lt 0 ]; then
        log "TLS: FAIL - Certificate has expired"
         FAILED=1
    elif [ "$DAYS_LEFT" -lt 30 ]; then
        log "TLS: WARNING - Certificate expires in $DAYS_LEFT days"
    else
        log "TLS: PASS - Certificate expires in $DAYS_LEFT days"
    fi
else
    log "TLS: FAIL - Could not retrieve certificate"
    FAILED=1
fi

#HTTPS STATUS CODE CHECK

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$HOST")

if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 400 ]; then
log "HTTP: PASS - Status $HTTP_STATUS"
else
log "HTTP: FAIL - Status $HTTP_STATUS"
 FAILED=1
fi

echo ""

if [ "$FAILED" -eq 0 ]; then
    log "Overall: HEALTHY"
    exit 0
else
    log "Overall: UNHEALTHY"
    exit 1
fi
