# Quick Start: Deploy to Render.com

## 🚀 Quick Deployment Steps

1. **Push your code to GitHub/GitLab/Bitbucket**
   ```bash
   git add .
   git commit -m "Prepare for Render deployment"
   git push
   ```

2. **Connect to Render Dashboard**
   - Go to [dashboard.render.com](https://dashboard.render.com)
   - Click **"New +"** → **"Blueprint"**
   - Connect your repository
   - Render will auto-detect `render.yaml` and create all 3 services automatically

3. **Wait for Initial Deployment** (5-10 minutes)
   - Database, Backend, and Frontend will deploy automatically
   - Most environment variables are auto-configured ✅

4. **Set Google OAuth2 Credentials** (ONLY manual step!)
   - Click on **"auto-servis-backend"** service
   - Go to **"Environment"** tab
   - Add environment variable:
     - Key: `GOOGLE_CLIENT_ID` → Value: Your Google Client ID
   - Add environment variable:
     - Key: `GOOGLE_CLIENT_SECRET` → Value: Your Google Client Secret
   - Service will auto-redeploy after saving

5. **Update Google OAuth2 Console**
   - Go to [Google Cloud Console](https://console.cloud.google.com)
   - Add redirect URI: `https://auto-servis-frontend.onrender.com/login/oauth2/code/google`

6. **Initialize Database**
   - Connect to database using Render's connection string
   - Run: `BAZA/AutoServisBaza.sql`
   - Optionally run: `BAZA/PopunjenjeBaze.sql`

## 📋 What's Configured

✅ **Database** - PostgreSQL (auto-configured)  
✅ **Backend** - Spring Boot API (auto-configured)  
✅ **Frontend** - React/Vite with Nginx (auto-configured)  
✅ **Environment Variables** - Most are auto-configured  
⚠️ **Google OAuth2** - You must set manually  

## 🔗 Your URLs (after deployment)

- Frontend: `https://auto-servis-frontend.onrender.com`
- Backend: `https://auto-servis-backend.onrender.com`

## 📚 Full Documentation

- **[RENDER_DASHBOARD_STEPS.md](./RENDER_DASHBOARD_STEPS.md)** - Detailed step-by-step dashboard guide
- **[RENDER_DEPLOYMENT.md](./RENDER_DEPLOYMENT.md)** - Complete deployment documentation and troubleshooting

## 💡 How Environment Variables Work

**On Render:**
- ✅ Environment variables are set automatically via `render.yaml`
- ✅ Spring Boot reads them directly (no .env file needed)
- ✅ Only `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` need manual setup

**For Local Development:**
- Copy `backend/env.example` to `backend/.env`
- Fill in your local values
- The app will automatically load from `.env` file

