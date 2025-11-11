#!/bin/sh
# Startup script to ensure BACKEND_URL is set before nginx starts

# If BACKEND_URL is empty or not set, set a default
if [ -z "$BACKEND_URL" ]; then
  echo "WARNING: BACKEND_URL is not set, using default localhost:8080"
  export BACKEND_URL="http://localhost:8080"
  export BACKEND_HOST_ONLY="localhost:8080"
else
  # Remove any existing protocol to normalize
  BACKEND_HOST="${BACKEND_URL#http://}"
  BACKEND_HOST="${BACKEND_HOST#https://}"
  # Remove trailing slash if present
  BACKEND_HOST="${BACKEND_HOST%/}"
  
  # If BACKEND_HOST doesn't contain a dot, it's likely just a service name
  # Append .onrender.com to make it a proper hostname
  if [ "$BACKEND_HOST" = "${BACKEND_HOST#*.}" ]; then
    echo "WARNING: BACKEND_URL appears to be just a service name, appending .onrender.com"
    BACKEND_HOST="${BACKEND_HOST}.onrender.com"
  fi
  
  # Use HTTPS for backend communication
  # Render's public URLs require HTTPS (HTTP redirects to HTTPS causing loops)
  # The backend runs on HTTP internally, but Render's load balancer exposes it via HTTPS
  # Store both the full URL and just the hostname
  export BACKEND_URL="https://$BACKEND_HOST"
  export BACKEND_HOST_ONLY="$BACKEND_HOST"
fi

echo "Using BACKEND_URL: $BACKEND_URL"
echo "Using BACKEND_HOST_ONLY: $BACKEND_HOST_ONLY"

# Export variables so envsubst can use them
export BACKEND_URL
export BACKEND_HOST_ONLY

# Start nginx with the official entrypoint (which runs envsubst on templates)
exec /docker-entrypoint.sh nginx -g "daemon off;"

