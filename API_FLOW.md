# API Request Flow: Frontend → Backend

## What Frontend Sends

**Frontend URL:** `https://auto-servis-frontend.onrender.com`

**Frontend sends (from browser):**
- `GET https://auto-servis-frontend.onrender.com/api/marke`
- `GET https://auto-servis-frontend.onrender.com/api/usluge`
- `GET https://auto-servis-frontend.onrender.com/api/serviseri`
- `GET https://auto-servis-frontend.onrender.com/api/user`
- `GET https://auto-servis-frontend.onrender.com/api/zamjenska-vozila/slobodna`
- `POST https://auto-servis-frontend.onrender.com/api/nalog`

**Frontend code uses:** Relative paths like `/api/marke` (from `api.js`)

## What Backend Expects

**Backend URL:** `https://auto-servis-backend.onrender.com`

**Backend expects (from README.md):**
- `GET https://auto-servis-backend.onrender.com/api/marke`
- `GET https://auto-servis-backend.onrender.com/api/usluge`
- `GET https://auto-servis-backend.onrender.com/api/serviseri`
- `GET https://auto-servis-backend.onrender.com/api/user`
- `GET https://auto-servis-backend.onrender.com/api/zamjenska-vozila/slobodna`
- `POST https://auto-servis-backend.onrender.com/api/nalog`

**All endpoints start with `/api/`** - this is important!

## How Nginx Proxies

**Current Setup:**
1. Browser sends: `GET https://auto-servis-frontend.onrender.com/api/marke`
2. Nginx receives request at `/api/marke`
3. Nginx matches `location /api/` block
4. Nginx proxies to: `https://auto-servis-backend.onrender.com/api/marke`
5. Backend receives: `GET /api/marke` with Host header `auto-servis-backend.onrender.com`

**Path Preservation:**
- When `location /api/` (with trailing slash) and `proxy_pass ${BACKEND_URL}` (no trailing slash)
- Nginx preserves the full path: `/api/marke` → `${BACKEND_URL}/api/marke` ✅

## The Problem: Redirect Loop

The redirect loop (`ERR_TOO_MANY_REDIRECTS`) suggests:
1. Backend might be redirecting requests
2. Or nginx is creating a redirect loop
3. Or CORS/Origin header issues

## Solution

The nginx config should:
- ✅ Preserve the `/api/` prefix (already doing this)
- ✅ Use backend hostname in Host header (already doing this)
- ✅ Use HTTPS to backend (already doing this)
- ⚠️ Ensure Origin header is correct for CORS
- ⚠️ Don't modify redirects unnecessarily

