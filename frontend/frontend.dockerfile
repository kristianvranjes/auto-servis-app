
# Multi-stage build: build the Vite app with Node, serve with nginx in production
FROM node:22-alpine AS build

WORKDIR /app

# Install dependencies (use npm ci for reproducible builds)
COPY package*.json ./
RUN npm ci --silent

# Copy source and build
COPY . .
RUN npm run build

FROM nginx:stable-alpine

# Remove default nginx website, copy built files
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/dist /usr/share/nginx/html

# SPA routing: fallback to index.html for unknown routes
# Copy nginx template so the official nginx image can run envsubst on it at
# container start. The entrypoint will substitute ${BACKEND_URL} into the
# generated /etc/nginx/conf.d/default.conf.
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

# Copy startup script to ensure BACKEND_URL is set before nginx starts
COPY start-nginx.sh /start-nginx.sh
RUN chmod +x /start-nginx.sh

EXPOSE 80
CMD ["/start-nginx.sh"]