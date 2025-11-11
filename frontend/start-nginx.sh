#!/bin/sh
# Startup script to ensure BACKEND_URL is set before nginx starts

# If BACKEND_URL is empty or not set, set a default
if [ -z "$BACKEND_URL" ]; then
  echo "WARNING: BACKEND_URL is not set, using default localhost:8080"
  export BACKEND_URL="http://localhost:8080"
else
  # Remove any existing protocol to normalize
  BACKEND_HOST="${BACKEND_URL#http://}"
  BACKEND_HOST="${BACKEND_HOST#https://}"
  
  # If BACKEND_HOST doesn't contain a dot, it's likely just a service name
  # Append .onrender.com to make it a proper hostname
  if [ "$BACKEND_HOST" = "${BACKEND_HOST#*.}" ]; then
    echo "WARNING: BACKEND_URL appears to be just a service name, appending .onrender.com"
    BACKEND_HOST="${BACKEND_HOST}.onrender.com"
  fi
  
  # Use HTTP for backend communication
  # Backend runs on HTTP (port 8080), Render's load balancer handles HTTPS externally
  # Internal service-to-service communication should use HTTP
  export BACKEND_URL="http://$BACKEND_HOST"
fi

echo "Using BACKEND_URL: $BACKEND_URL"

# Export BACKEND_URL so envsubst can use it
export BACKEND_URL

# Start nginx with the official entrypoint (which runs envsubst on templates)
exec /docker-entrypoint.sh nginx -g "daemon off;"

