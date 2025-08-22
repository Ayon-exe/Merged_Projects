#!/bin/bash

echo "=== DeepCytes Application Gateway Startup ==="
echo "Starting all services in the correct order..."

# Get the base directory
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPLIANCE_DIR="$BASE_DIR/Compliance-Platform-DeepCytes"
THREATMAP_DIR="$BASE_DIR/ThreatMap"
NGINX_DIR="$BASE_DIR/master-nginx"

# Function to check if a service is running
check_service() {
    local port=$1
    local name=$2
    echo "Checking if $name is running on port $port..."
    if curl -s "http://localhost:$port/health" > /dev/null 2>&1; then
        echo "✓ $name is running on port $port"
        return 0
    else
        echo "✗ $name is not responding on port $port"
        return 1
    fi
}

# Function to wait for service to be ready
wait_for_service() {
    local port=$1
    local name=$2
    local max_attempts=30
    local attempt=1
    
    echo "Waiting for $name to be ready on port $port..."
    while [ $attempt -le $max_attempts ]; do
        if check_service $port "$name"; then
            return 0
        fi
        echo "Attempt $attempt/$max_attempts: $name not ready yet, waiting 10 seconds..."
        sleep 10
        attempt=$((attempt + 1))
    done
    
    echo "ERROR: $name failed to start after $max_attempts attempts"
    return 1
}

# Start ThreatMap
echo ""
echo "1. Starting ThreatMap..."
cd "$THREATMAP_DIR"
docker-compose down > /dev/null 2>&1
docker-compose up -d
if [ $? -eq 0 ]; then
    echo "✓ ThreatMap containers started"
    wait_for_service 5544 "ThreatMap"
else
    echo "✗ Failed to start ThreatMap"
    exit 1
fi

# Start Compliance Platform
echo ""
echo "2. Starting Compliance Platform..."
cd "$COMPLIANCE_DIR"
docker-compose down > /dev/null 2>&1
docker-compose up -d
if [ $? -eq 0 ]; then
    echo "✓ Compliance Platform containers started"
    wait_for_service 5500 "Compliance Platform"
else
    echo "✗ Failed to start Compliance Platform"
    exit 1
fi

# Start Master Nginx Gateway
echo ""
echo "3. Starting Master Nginx Gateway..."
cd "$NGINX_DIR"
docker-compose down > /dev/null 2>&1
docker-compose up -d
if [ $? -eq 0 ]; then
    echo "✓ Master Nginx Gateway started"
    wait_for_service 80 "Master Nginx Gateway"
else
    echo "✗ Failed to start Master Nginx Gateway"
    exit 1
fi

echo ""
echo "=== All Services Started Successfully! ==="
echo ""
echo "🌐 Access your applications:"
echo "   Main Gateway:    http://localhost/"
echo "   ThreatMap:       http://localhost/threatmap"
echo "   Compliance:      http://localhost/compliance"
echo ""
echo "🔧 Service URLs (direct access):"
echo "   ThreatMap:       http://localhost:5544"
echo "   Compliance:      http://localhost:5500"
echo ""
echo "📊 Health Checks:"
echo "   Gateway Health:  http://localhost/health"
echo "   ThreatMap:       http://localhost:5544/health"
echo "   Compliance:      http://localhost:5500/health"
echo ""
echo "Use 'docker-compose logs -f' in each directory to view logs"
echo "Use './stop-all.sh' to stop all services"
