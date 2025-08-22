# DeepCytes Application Gateway

This repository contains a master Nginx gateway that routes traffic between two main applications:
- **ThreatMap**: Live Cyber Threat Map (accessible via `/threatmap`)
- **Compliance Platform**: Compliance 360 Platform (accessible via `/compliance`)

## Architecture Overview

```
User Request (Port 80)
         ↓
   Master Nginx Gateway
         ↓
    ┌────────────────────┐
    ↓                    ↓
/threatmap          /compliance
    ↓                    ↓
ThreatMap Nginx    Compliance Nginx
  (Port 5544)        (Port 5500)
    ↓                    ↓
Backend + Frontend  Backend + Frontend
```

## Port Mappings

### Master Gateway
- **Port 80**: Main entry point for all traffic

### ThreatMap Project
- **Port 5544**: ThreatMap Nginx (external access)
- **Backend**: Flask on port 5000 (internal)
- **Frontend**: Nginx on port 80 (internal)

### Compliance Platform
- **Port 5500**: Compliance Nginx (external access)
- **Port 3000**: Next.js Frontend (internal)
- **Port 3001**: Node.js Backend (internal)
- **Port 27017**: MongoDB (external access)

## Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Ports 80, 5500, 5544, 27017 available on your system

### Starting All Services

#### Windows (PowerShell)
```powershell
.\start-all.ps1
```

#### Linux/Mac (Bash)
```bash
chmod +x start-all.sh
./start-all.sh
```

### Stopping All Services

#### Windows (PowerShell)
```powershell
.\stop-all.ps1
```

#### Linux/Mac (Bash)
```bash
./stop-all.sh
```

## Access URLs

Once all services are running:

### Main Access Points
- **Gateway Home**: http://localhost/
- **ThreatMap**: http://localhost/threatmap
- **Compliance Platform**: http://localhost/compliance

### Direct Service Access (Bypass Gateway)
- **ThreatMap Direct**: http://localhost:5544
- **Compliance Direct**: http://localhost:5500

### Health Checks
- **Gateway Health**: http://localhost/health
- **ThreatMap Health**: http://localhost:5544/health
- **Compliance Health**: http://localhost:5500/health

## Manual Setup (Alternative)

If you prefer to start services manually:

### 1. Start ThreatMap
```bash
cd ThreatMap
docker-compose up -d
```

### 2. Start Compliance Platform
```bash
cd Compliance-Platform-DeepCytes
docker-compose up -d
```

### 3. Start Master Gateway
```bash
cd master-nginx
docker-compose up -d
```

## Troubleshooting

### Common Issues

1. **Port Conflicts**
   - Ensure ports 80, 5500, 5544, 27017 are not in use
   - Check with: `netstat -an | findstr ":80 :5500 :5544 :27017"`

2. **Services Not Starting**
   - Check Docker is running
   - Verify Docker Compose version: `docker-compose --version`
   - Check logs: `docker-compose logs -f` in respective directories

3. **Gateway Returns 502 Bad Gateway**
   - Ensure both ThreatMap and Compliance Platform are running
   - Check if services are healthy: visit health check URLs
   - Wait a few minutes for all services to fully initialize

4. **Database Connection Issues**
   - Ensure MongoDB is running: `docker ps | grep mongodb`
   - Check MongoDB logs: `cd Compliance-Platform-DeepCytes && docker-compose logs mongodb`

### Viewing Logs

#### All Services
```bash
# ThreatMap logs
cd ThreatMap && docker-compose logs -f

# Compliance Platform logs
cd Compliance-Platform-DeepCytes && docker-compose logs -f

# Master Gateway logs
cd master-nginx && docker-compose logs -f
```

#### Specific Service
```bash
docker logs threat-map-nginx
docker logs compliance-nginx
docker logs master-nginx-gateway
```

### Container Status
```bash
# View all containers
docker ps -a

# View specific project containers
docker-compose ps  # (run from respective project directory)
```

## Configuration Files

### Master Nginx Configuration
- **Location**: `master-nginx/nginx.conf`
- **Purpose**: Routes traffic between applications
- **Key Features**:
  - Path-based routing (`/threatmap`, `/compliance`)
  - Health checks
  - Static file caching
  - WebSocket support for development
  - CORS headers

### ThreatMap Configuration
- **Docker Compose**: `ThreatMap/docker-compose.yml`
- **Nginx Config**: `ThreatMap/nginx.conf`
- **External Port**: 5544

### Compliance Platform Configuration
- **Docker Compose**: `Compliance-Platform-DeepCytes/docker-compose.yml`
- **Nginx Config**: `Compliance-Platform-DeepCytes/nginx/nginx.conf`
- **External Port**: 5500

## Development Notes

### Hot Reload Support
- Next.js hot reload works through WebSocket proxying
- Changes to frontend code should reflect immediately in browser

### API Endpoints
- ThreatMap API: `http://localhost/threatmap/api/`
- Compliance API: `http://localhost/compliance/api/`

### Static Assets
- All static assets are properly proxied through the gateway
- Caching headers are set for optimal performance

## Security Considerations

### Headers
- X-Frame-Options: SAMEORIGIN
- X-Content-Type-Options: nosniff
- X-XSS-Protection: enabled

### CORS
- Configured for development/testing
- Review CORS settings for production deployment

## Production Deployment

For production deployment, consider:

1. **SSL/TLS Configuration**
   - Add SSL certificates
   - Redirect HTTP to HTTPS
   - Update security headers

2. **Environment Variables**
   - Update API URLs
   - Configure production databases
   - Set secure passwords

3. **Monitoring**
   - Add health check endpoints
   - Configure log aggregation
   - Set up performance monitoring

4. **Backup Strategy**
   - MongoDB backup configuration
   - Volume backup for persistent data

## Support

For issues or questions:
1. Check logs using commands above
2. Verify all prerequisites are met
3. Ensure no other services are using required ports
4. Review the troubleshooting section

## File Structure

```
merged-projects/
├── master-nginx/              # Master gateway configuration
│   ├── nginx.conf            # Main routing configuration
│   └── docker-compose.yml    # Gateway service definition
├── ThreatMap/                # ThreatMap project
│   ├── docker-compose.yml    # ThreatMap services
│   └── nginx.conf           # ThreatMap nginx config
├── Compliance-Platform-DeepCytes/  # Compliance platform
│   ├── docker-compose.yml    # Compliance services
│   └── nginx/               # Nginx configuration directory
├── start-all.ps1            # Windows startup script
├── start-all.sh             # Linux/Mac startup script
├── stop-all.ps1             # Windows stop script
├── stop-all.sh              # Linux/Mac stop script
└── README.md                # This file
```
