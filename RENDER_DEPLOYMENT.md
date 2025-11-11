# Deploying to Render.com

This guide will help you deploy the Auto Servis application to Render.com.

## Prerequisites

1. A [Render.com](https://render.com) account
2. A GitHub repository with your code (or GitLab/Bitbucket)
3. Google OAuth2 credentials (Client ID and Client Secret)

## Overview

The application consists of three services:
1. **PostgreSQL Database** - Stores application data
2. **Backend Service** - Spring Boot API (Java 21)
3. **Frontend Service** - React/Vite application served via Nginx

## Deployment Steps

### Step 1: Prepare Your Repository

1. Ensure all your code is committed and pushed to your Git repository
2. The `render.yaml` file in the root directory contains the service definitions

### Step 2: Connect Repository to Render

1. Log in to [Render Dashboard](https://dashboard.render.com)
2. Click **"New +"** → **"Blueprint"**
3. Connect your Git repository
4. Render will automatically detect the `render.yaml` file

### Step 3: Configure Environment Variables

After the services are created, you need to set up Google OAuth2 credentials:

1. Go to your **Backend Service** settings
2. Navigate to **Environment** tab
3. Add the following environment variables:
   - `GOOGLE_CLIENT_ID` - Your Google OAuth2 Client ID
   - `GOOGLE_CLIENT_SECRET` - Your Google OAuth2 Client Secret

**Important:** Make sure to add your Render frontend URL to your Google OAuth2 authorized redirect URIs:
- `https://auto-servis-frontend.onrender.com/login/oauth2/code/google`
- Or your custom domain if you set one up

### Step 4: Initialize the Database

1. Once the database is created, you need to run the SQL scripts:
   - Go to your **Database** service in Render
   - Click on **"Connect"** or use the **"psql"** command
   - Run the SQL scripts from `BAZA/AutoServisBaza.sql` to create tables
   - Optionally run `BAZA/PopunjenjeBaze.sql` to populate initial data

**Alternative:** You can use Render's database connection string to connect from your local machine:
```bash
psql <connection-string>
```

Then run:
```sql
\i BAZA/AutoServisBaza.sql
\i BAZA/PopunjenjeBaze.sql
```

### Step 5: Deploy

1. Render will automatically deploy when you create the Blueprint
2. Monitor the deployment logs in the Render dashboard
3. Wait for all services to show "Live" status

## Service URLs

After deployment, your services will be available at:
- **Frontend:** `https://auto-servis-frontend.onrender.com`
- **Backend:** `https://auto-servis-backend.onrender.com`
- **Database:** Internal connection only (not publicly accessible)

## Environment Variables Reference

### Backend Service
- `PORT` - Server port (automatically set by Render)
- `SPRING_DATASOURCE_URL` - Database connection string (auto-configured)
- `SPRING_DATASOURCE_USERNAME` - Database username (auto-configured)
- `SPRING_DATASOURCE_PASSWORD` - Database password (auto-configured)
- `FRONTEND_URL` - Frontend service URL (auto-configured)
- `GOOGLE_CLIENT_ID` - **You must set this manually**
- `GOOGLE_CLIENT_SECRET` - **You must set this manually**
- `SPRING_JPA_HIBERNATE_DDL_AUTO` - Set to `validate` (default)
- `SPRING_JPA_SHOW_SQL` - Set to `false` in production

### Frontend Service
- `BACKEND_URL` - Backend service URL (auto-configured)
- `PORT` - Nginx port (set to 80, auto-configured)

## Custom Domains

To use a custom domain:

1. Go to your service settings
2. Navigate to **"Custom Domains"**
3. Add your domain and follow Render's DNS configuration instructions
4. Update your Google OAuth2 redirect URIs to include the custom domain

## Troubleshooting

### Backend won't start
- Check the deployment logs for errors
- Verify all environment variables are set correctly
- Ensure the database is accessible and initialized
- Check that `PORT` environment variable is set (Render sets this automatically)

### Frontend can't connect to backend
- Verify `BACKEND_URL` environment variable is set correctly in frontend service
- Check that the backend service is "Live"
- Verify CORS settings in `SecurityConfig.java` allow your frontend URL

### Database connection errors
- Verify database credentials in backend environment variables
- Check that the database service is running
- Ensure database tables are created (run SQL scripts)

### OAuth2 not working
- Verify `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` are set
- Check that your Render frontend URL is added to Google OAuth2 authorized redirect URIs
- Ensure `FRONTEND_URL` is set correctly in backend service

## Free Tier Limitations

Render's free tier has some limitations:
- Services may spin down after 15 minutes of inactivity
- First request after spin-down may be slow (cold start)
- Database has connection limits
- Services may have memory/CPU limits

For production use, consider upgrading to a paid plan.

## Updating Your Application

1. Push changes to your Git repository
2. Render will automatically detect changes and redeploy
3. Monitor deployment logs to ensure successful deployment

## Health Checks

- **Backend:** `/api/health`
- **Frontend:** `/health`

These endpoints are used by Render to verify service health.

## Additional Resources

- [Render Documentation](https://render.com/docs)
- [Render Blueprint Spec](https://render.com/docs/blueprint-spec)
- [Spring Boot on Render](https://render.com/docs/deploy-spring-boot)

