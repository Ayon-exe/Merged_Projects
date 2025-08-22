@echo off
REM ThreatMap Docker Startup Script for Windows

echo 🚀 Starting ThreatMap Application...
echo ==================================

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker first.
    pause
    exit /b 1
)

REM Check if Docker Compose is available
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Compose is not installed.
    pause
    exit /b 1
)

echo ✅ Docker is running
echo ✅ Docker Compose is available

REM Build and start the application
echo.
echo 🔨 Building and starting services...
docker-compose up --build -d

REM Check if services are running
echo.
echo 📊 Service Status:
docker-compose ps

echo.
echo 🌐 Application is starting up...
echo 📍 URL: http://localhost:5544
echo.
echo 📋 Useful commands:
echo    View logs:           docker-compose logs -f
echo    Stop application:    docker-compose down
echo    Restart service:     docker-compose restart [service-name]
echo    Check status:        docker-compose ps
echo.
echo ⏳ Please wait a moment for all services to fully initialize...
pause
