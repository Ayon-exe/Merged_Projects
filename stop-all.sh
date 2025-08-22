#!/bin/bash

echo "=== Stopping DeepCytes Application Gateway ==="
echo "Stopping all services..."

# Get the base directory
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPLIANCE_DIR="$BASE_DIR/Compliance-Platform-DeepCytes"
THREATMAP_DIR="$BASE_DIR/ThreatMap"
NGINX_DIR="$BASE_DIR/master-nginx"

# Stop Master Nginx Gateway first
echo ""
echo "1. Stopping Master Nginx Gateway..."
cd "$NGINX_DIR"
docker-compose down
if [ $? -eq 0 ]; then
    echo "✓ Master Nginx Gateway stopped"
else
    echo "✗ Failed to stop Master Nginx Gateway"
fi

# Stop Compliance Platform
echo ""
echo "2. Stopping Compliance Platform..."
cd "$COMPLIANCE_DIR"
docker-compose down
if [ $? -eq 0 ]; then
    echo "✓ Compliance Platform stopped"
else
    echo "✗ Failed to stop Compliance Platform"
fi

# Stop ThreatMap
echo ""
echo "3. Stopping ThreatMap..."
cd "$THREATMAP_DIR"
docker-compose down
if [ $? -eq 0 ]; then
    echo "✓ ThreatMap stopped"
else
    echo "✗ Failed to stop ThreatMap"
fi

# Clean up any orphaned containers
echo ""
echo "4. Cleaning up orphaned containers..."
docker container prune -f > /dev/null 2>&1

echo ""
echo "=== All Services Stopped ==="
