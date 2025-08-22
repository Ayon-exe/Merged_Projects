# Development Start Script for ThreatMap
# This script starts the ThreatMap in development mode with hot reload

Write-Host "Starting ThreatMap in Development Mode..." -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# Navigate to ThreatMap directory
Set-Location "ThreatMap"

# Stop any existing containers
Write-Host "Stopping existing containers..." -ForegroundColor Yellow
docker-compose -f docker-compose.dev.yml down

# Build and start development containers
Write-Host "Building and starting development containers..." -ForegroundColor Yellow
docker-compose -f docker-compose.dev.yml up --build -d

# Show container status
Write-Host "Container Status:" -ForegroundColor Green
docker-compose -f docker-compose.dev.yml ps

Write-Host "" -ForegroundColor White
Write-Host "Development servers are starting..." -ForegroundColor Green
Write-Host "Frontend (Vite): http://localhost:5173" -ForegroundColor Cyan
Write-Host "Backend (Flask): http://localhost:5000" -ForegroundColor Cyan
Write-Host "Full App (Nginx): http://localhost:5544" -ForegroundColor Cyan
Write-Host "" -ForegroundColor White
Write-Host "To view logs: docker-compose -f docker-compose.dev.yml logs -f" -ForegroundColor Yellow
Write-Host "To stop: docker-compose -f docker-compose.dev.yml down" -ForegroundColor Yellow

# Go back to original directory
Set-Location ".."
