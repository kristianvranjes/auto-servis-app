#!/bin/sh
# Startup script to ensure BACKEND_URL is set before nginx starts

# If BACKEND_URL is empty or not set, set a default
if [ -z "$BACKEND_URL" ]; then
  echo "WARNING: BACKEND_URL is not set, using default localhost:8080"
  export BACKEND_URL="http://localhost:8080"
fi

# Ensure BACKEND_URL has a protocol
if [ "${BACKEND_URL#http://}" = "$BACKEND_URL" ] && [ "${BACKEND_URL#https://}" = "$BACKEND_URL" ]; then
  echo "WARNING: BACKEND_URL missing protocol, adding https://"
  export BACKEND_URL="https://$BACKEND_URL"
fi

echo "Using BACKEND_URL: $BACKEND_URL"

# Export BACKEND_URL so envsubst can use it
export BACKEND_URL

# Start nginx with the official entrypoint (which runs envsubst on templates)
exec /docker-entrypoint.sh nginx -g "daemon off;"

