# ThreatMap Docker Setup

This project has been fully dockerized with Docker Compose for easy deployment and development.

## Architecture

The application consists of:
- **Frontend**: React/TypeScript application built with Vite
- **Backend**: Python Flask application with real-time threat intelligence
- **Nginx**: Reverse proxy server listening on port 5544

## Quick Start

1. Make sure you have Docker and Docker Compose installed
2. Clone this repository
3. Run the application:

```bash
docker-compose up --build
```

4. Access the application at: http://localhost:5544

## Services

### Backend (Python Flask)
- **Port**: 5000 (internal)
- **Technology**: Flask, asyncio, gunicorn
- **Features**: 
  - Real-time threat data streaming (SSE)
  - News feed aggregation
  - Malicious IP intelligence
  - GeoIP location services

### Frontend (React)
- **Port**: 80 (internal)
- **Technology**: React, TypeScript, Vite, TailwindCSS
- **Features**:
  - Interactive world map
  - Real-time threat visualization
  - News dashboard
  - Attack statistics

### Nginx Proxy
- **Port**: 5544 (external)
- **Features**:
  - Load balancing
  - Static file serving
  - API proxying
  - CORS handling
  - Health checks

## Development

### Building Individual Services

Backend:
```bash
cd "Source Code/DC_LCTM_Backend"
docker build -t threat-map-backend .
```

Frontend:
```bash
cd "Source Code/DC_LCTM_Frontend-v2"
docker build -t threat-map-frontend .
```

### Environment Variables

The backend supports these environment variables:
- `FLASK_ENV`: Set to 'production' for production builds
- `PYTHONUNBUFFERED`: Set to '1' for immediate stdout/stderr output

### Volumes

- Backend assets are mounted as read-only volumes for GeoIP database access

### Health Checks

Both backend and nginx services include health checks:
- Backend: HTTP GET to `/`
- Nginx: HTTP GET to `/`

## API Endpoints (via Nginx Proxy)

- `/threats` - Server-Sent Events for real-time threat data
- `/news` - REST API for cybersecurity news
- `/malicious-ips` - REST API for malicious IP data

## Troubleshooting

### Check service logs:
```bash
docker-compose logs [service-name]
```

### Restart specific service:
```bash
docker-compose restart [service-name]
```

### Rebuild and restart:
```bash
docker-compose down
docker-compose up --build
```

### Check service health:
```bash
docker-compose ps
```

## Production Considerations

- The setup uses `restart: unless-stopped` for automatic container recovery
- Gunicorn is configured with 4 workers and eventlet for async support
- Nginx provides gzip compression and security headers
- Health checks ensure service availability
- Non-root users are used in containers for security

## Scaling

To scale the backend:
```bash
docker-compose up --scale backend=3
```

Note: You may need to configure nginx load balancing for multiple backend instances.
