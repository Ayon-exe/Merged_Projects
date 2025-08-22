# DeepCytes Application Gateway Stop Script
# PowerShell version for Windows

Write-Host "=== Stopping DeepCytes Application Gateway ===" -ForegroundColor Red
Write-Host "Stopping all services..." -ForegroundColor Yellow

# Get the base directory
$BASE_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$COMPLIANCE_DIR = Join-Path $BASE_DIR "Compliance-Platform-DeepCytes"
$THREATMAP_DIR = Join-Path $BASE_DIR "ThreatMap"
$NGINX_DIR = Join-Path $BASE_DIR "master-nginx"

# Stop Master Nginx Gateway first
Write-Host ""
Write-Host "1. Stopping Master Nginx Gateway..." -ForegroundColor Magenta
Set-Location $NGINX_DIR
& docker-compose down
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Master Nginx Gateway stopped" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to stop Master Nginx Gateway" -ForegroundColor Red
}

# Stop Compliance Platform
Write-Host ""
Write-Host "2. Stopping Compliance Platform..." -ForegroundColor Magenta
Set-Location $COMPLIANCE_DIR
& docker-compose down
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Compliance Platform stopped" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to stop Compliance Platform" -ForegroundColor Red
}

# Stop ThreatMap
Write-Host ""
Write-Host "3. Stopping ThreatMap..." -ForegroundColor Magenta
Set-Location $THREATMAP_DIR
& docker-compose down
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ ThreatMap stopped" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to stop ThreatMap" -ForegroundColor Red
}

# Clean up any orphaned containers
Write-Host ""
Write-Host "4. Cleaning up orphaned containers..." -ForegroundColor Magenta
& docker container prune -f 2>$null

Write-Host ""
Write-Host "=== All Services Stopped ===" -ForegroundColor Green
