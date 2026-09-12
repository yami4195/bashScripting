#!/bin/bash

URL="$1"

echo "Checking $URL"

WITH_OUT_PROTOCOL="${URL#*://}"
HOST="${WITH_OUT_PROTOCOL%%/*}"
echo "Url: $URL"
echo "Hostname:$HOST"
