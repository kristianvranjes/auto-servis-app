### Root Dockerfile to build and serve the frontend (static site)
###
### This multi-stage Dockerfile builds the Vite React app located in ./frontend
### and serves the static files with nginx. It's intended for platforms like
### Render that expect a Dockerfile at the repository root.

FROM node:22-bullseye-slim AS build-frontend
WORKDIR /app/frontend

# Install dependencies (uses package-lock.json in frontend/)
COPY frontend/package*.json ./
COPY frontend/package-lock.json ./
RUN npm ci --production=false

# Copy frontend sources and build
COPY frontend/ ./
ARG VITE_BACKEND_URL
ENV VITE_BACKEND_URL=${VITE_BACKEND_URL}
RUN npm run build

FROM nginx:stable-alpine

# Remove default nginx content and copy built files
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build-frontend /app/frontend/dist /usr/share/nginx/html

# Copy frontend nginx config if present (falls back to default server block)
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
