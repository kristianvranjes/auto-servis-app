# Step-by-Step: Render Dashboard Setup

This guide walks you through exactly what to do in the Render dashboard.

## Step 1: Connect Your Repository

1. Go to [dashboard.render.com](https://dashboard.render.com)
2. Click the **"New +"** button (top right)
3. Select **"Blueprint"**
4. Connect your Git provider (GitHub/GitLab/Bitbucket)
5. Select your repository: `mojrepo` (or your repo name)
6. Click **"Apply"**

Render will automatically:
- ✅ Detect the `render.yaml` file
- ✅ Create all 3 services (Database, Backend, Frontend)
- ✅ Configure most environment variables automatically

## Step 2: Wait for Initial Deployment

1. You'll see 3 services being created:
   - `auto-servis-database` (PostgreSQL)
   - `auto-servis-backend` (Spring Boot)
   - `auto-servis-frontend` (React/Nginx)

2. Wait for all services to finish deploying (may take 5-10 minutes)
   - Green "Live" status = Success
   - Red status = Check logs for errors

## Step 3: Set Google OAuth2 Credentials

**This is the ONLY manual step you need to do!**

1. Click on **"auto-servis-backend"** service
2. Go to **"Environment"** tab (left sidebar)
3. Scroll down to find the environment variables section
4. Click **"Add Environment Variable"** button
5. Add these two variables:

   **Variable 1:**
   - **Key:** `GOOGLE_CLIENT_ID`
   - **Value:** Your Google OAuth2 Client ID
   - Click **"Save Changes"**

   **Variable 2:**
   - **Key:** `GOOGLE_CLIENT_SECRET`
   - **Value:** Your Google OAuth2 Client Secret
   - Click **"Save Changes"**

6. After adding both, the service will automatically redeploy

## Step 4: Update Google OAuth2 Console

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Navigate to **APIs & Services** → **Credentials**
3. Find your OAuth2 Client ID
4. Click **Edit**
5. Under **"Authorized redirect URIs"**, add:
   ```
   https://auto-servis-frontend.onrender.com/login/oauth2/code/google
   ```
   (Replace `auto-servis-frontend` with your actual frontend service name if different)
6. Click **Save**

## Step 5: Initialize Database

1. Click on **"auto-servis-database"** service
2. Go to **"Info"** tab
3. Find the **"Connections"** section
4. Copy the **"Internal Database URL"** or use the **"psql"** command shown

**Option A: Using Render's Shell**
1. Click on **"auto-servis-database"** service
2. Go to **"Shell"** tab
3. Run:
   ```sql
   \i /path/to/AutoServisBaza.sql
   ```
   (You'll need to upload the SQL file first)

**Option B: Using Local psql (Recommended)**
1. Copy the connection string from Render dashboard
2. On your local machine, run:
   ```bash
   psql "postgresql://user:password@host:port/database"
   ```
3. Then run:
   ```sql
   \i BAZA/AutoServisBaza.sql
   \i BAZA/PopunjenjeBaze.sql
   ```

**Option C: Using Render's Database Dashboard**
1. Some Render plans include a database dashboard
2. You can paste and run SQL directly there

## Step 6: Verify Everything Works

1. **Check Backend:**
   - Go to: `https://auto-servis-backend.onrender.com/api/health`
   - Should return: `{"status":"ok"}` or similar

2. **Check Frontend:**
   - Go to: `https://auto-servis-frontend.onrender.com`
   - Should show your React app

3. **Test OAuth2:**
   - Try logging in with Google
   - Should redirect to Google login page

## That's It! 🎉

All other environment variables are automatically configured by Render:
- ✅ Database connection (auto-configured)
- ✅ Frontend URL (auto-configured)
- ✅ Backend URL (auto-configured)
- ✅ Port settings (auto-configured)

## Troubleshooting

### Services won't start
- Check the **"Logs"** tab for each service
- Common issues:
  - Database not initialized → Run SQL scripts
  - Missing Google OAuth2 credentials → Add them in Step 3
  - Build errors → Check Dockerfile paths

### Can't connect to database
- Verify database service is "Live"
- Check that `SPRING_DATASOURCE_URL` is set (should be auto-configured)
- Verify database credentials in backend environment variables

### OAuth2 not working
- Verify `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` are set
- Check redirect URI matches exactly in Google Console
- Ensure `FRONTEND_URL` is set correctly (should be auto-configured)

## Viewing Your URLs

After deployment, you can find your service URLs:
1. Click on any service
2. Go to **"Info"** tab
3. Your URL is shown at the top (e.g., `https://auto-servis-frontend.onrender.com`)

