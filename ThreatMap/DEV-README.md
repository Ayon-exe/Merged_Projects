# ThreatMap Development Setup

This document explains how to run ThreatMap in development mode for testing and development purposes.

## Quick Start

### Option 1: Development Mode (Recommended for Development)
```powershell
# Run the development start script
.\start-threatmap-dev.ps1
```

This will start:
- Frontend with Vite dev server (hot reload) on port 5173
- Backend with Flask development server on port 5000
- Nginx proxy on port 5544

### Option 2: Production-like Mode (For Testing)
```powershell
cd ThreatMap
docker-compose up --build
```

This will start:
- Frontend with built files served by Vite preview on port 4173
- Backend with Flask development server
- Nginx proxy on port 5544

## Development vs Production Mode

### Development Mode (`docker-compose.dev.yml`)
- **Frontend**: Vite dev server with hot reload
- **Backend**: Flask development server with debug mode
- **Volumes**: Source code mounted for live editing
- **Ports**: Direct access to frontend (5173) and backend (5000)
- **Environment**: `FLASK_ENV=development`, `FLASK_DEBUG=1`

### Production-like Mode (`docker-compose.yml`)
- **Frontend**: Built application served by Vite preview
- **Backend**: Flask development server (not gunicorn for easier debugging)
- **Volumes**: No source code mounting
- **Ports**: Access through nginx proxy only
- **Environment**: `FLASK_ENV=development` (still dev for testing)

## Key Changes Made

1. **Frontend Dockerfile**: 
   - Now installs ALL dependencies (including dev dependencies)
   - Uses `npm install` instead of `npm ci` (no package-lock.json required)
   - Serves built files with Vite preview on port 4173

2. **Frontend Dockerfile.dev**:
   - Runs Vite dev server with hot reload
   - Mounts source code as volumes for live editing
   - Serves on port 5173

3. **Backend Dockerfile**:
   - Uses Flask development server instead of gunicorn
   - Adds curl for health checks
   - Easier debugging and development

4. **Nginx Configuration**:
   - Updated upstream ports for development
   - Added WebSocket support for Vite HMR in dev mode

## URLs

- **Development Mode**:
  - Frontend: http://localhost:5173 (direct access with hot reload)
  - Backend: http://localhost:5000 (direct access)
  - Full App: http://localhost:5544 (through nginx)

- **Production-like Mode**:
  - Full App: http://localhost:5544 (through nginx only)

## Troubleshooting

1. **Build fails with npm ci error**: 
   - This is fixed by using `npm install` instead of `npm ci`
   - The new Dockerfile doesn't require package-lock.json

2. **Port conflicts**:
   - Stop existing containers: `docker-compose down`
   - Check for conflicting services on ports 5000, 5173, 5544

3. **Hot reload not working**:
   - Make sure you're using the development mode (`docker-compose.dev.yml`)
   - Check that volumes are properly mounted

## Commands

```powershell
# Start development mode
docker-compose -f docker-compose.dev.yml up --build

# Start production-like mode  
docker-compose up --build

# View logs
docker-compose logs -f

# Stop containers
docker-compose down

# Rebuild without cache
docker-compose build --no-cache
```
