#!/bin/bash

# ThreatMap Docker Startup Script

echo "🚀 Starting ThreatMap Application..."
echo "=================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose > /dev/null 2>&1; then
    echo "❌ Docker Compose is not installed."
    exit 1
fi

echo "✅ Docker is running"
echo "✅ Docker Compose is available"

# Build and start the application
echo ""
echo "🔨 Building and starting services..."
docker-compose up --build -d

# Check if services are running
echo ""
echo "📊 Service Status:"
docker-compose ps

echo ""
echo "🌐 Application is starting up..."
echo "📍 URL: http://localhost:5544"
echo ""
echo "📋 Useful commands:"
echo "   View logs:           docker-compose logs -f"
echo "   Stop application:    docker-compose down"
echo "   Restart service:     docker-compose restart [service-name]"
echo "   Check status:        docker-compose ps"
echo ""
echo "⏳ Please wait a moment for all services to fully initialize..."
