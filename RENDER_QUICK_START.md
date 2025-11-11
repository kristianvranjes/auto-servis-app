# Quick Start: Deploy to Render.com

## 🚀 Quick Deployment Steps

1. **Push your code to GitHub/GitLab/Bitbucket**
   ```bash
   git add .
   git commit -m "Prepare for Render deployment"
   git push
   ```

2. **Connect to Render**
   - Go to [dashboard.render.com](https://dashboard.render.com)
   - Click **"New +"** → **"Blueprint"**
   - Connect your repository
   - Render will auto-detect `render.yaml`

3. **Set Google OAuth2 Credentials**
   - After services are created, go to **Backend Service** → **Environment**
   - Add:
     - `GOOGLE_CLIENT_ID` = Your Google Client ID
     - `GOOGLE_CLIENT_SECRET` = Your Google Client Secret
   - Update Google OAuth2 console with redirect URI:
     - `https://auto-servis-frontend.onrender.com/login/oauth2/code/google`

4. **Initialize Database**
   - Connect to your database (use Render's connection info)
   - Run: `BAZA/AutoServisBaza.sql`
   - Optionally run: `BAZA/PopunjenjeBaze.sql`

5. **Wait for Deployment**
   - All services will deploy automatically
   - Check logs if any issues occur

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

See [RENDER_DEPLOYMENT.md](./RENDER_DEPLOYMENT.md) for detailed instructions and troubleshooting.

