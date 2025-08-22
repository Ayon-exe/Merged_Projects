# DeepCytes Application Gateway Startup Script
# PowerShell version for Windows

Write-Host "=== DeepCytes Application Gateway Startup ===" -ForegroundColor Green
Write-Host "Starting all services in the correct order..." -ForegroundColor Yellow

# Get the base directory
$BASE_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$COMPLIANCE_DIR = Join-Path $BASE_DIR "Compliance-Platform-DeepCytes"
$THREATMAP_DIR = Join-Path $BASE_DIR "ThreatMap"
$NGINX_DIR = Join-Path $BASE_DIR "master-nginx"

# Function to check if a service is running
function Test-Service {
    param([int]$Port, [string]$Name)
    
    Write-Host "Checking if $Name is running on port $Port..." -ForegroundColor Cyan
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$Port/health" -TimeoutSec 5 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "✓ $Name is running on port $Port" -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Host "✗ $Name is not responding on port $Port" -ForegroundColor Red
        return $false
    }
    return $false
}

# Function to wait for service to be ready
function Wait-ForService {
    param([int]$Port, [string]$Name, [int]$MaxAttempts = 30)
    
    Write-Host "Waiting for $Name to be ready on port $Port..." -ForegroundColor Yellow
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        if (Test-Service -Port $Port -Name $Name) {
            return $true
        }
        Write-Host "Attempt $attempt/$MaxAttempts`: $Name not ready yet, waiting 10 seconds..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
    }
    
    Write-Host "ERROR: $Name failed to start after $MaxAttempts attempts" -ForegroundColor Red
    return $false
}

# Start ThreatMap
Write-Host ""
Write-Host "1. Starting ThreatMap..." -ForegroundColor Magenta
Set-Location $THREATMAP_DIR
& docker-compose down 2>$null
& docker-compose up -d
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ ThreatMap containers started" -ForegroundColor Green
    if (-not (Wait-ForService -Port 5544 -Name "ThreatMap")) {
        exit 1
    }
} else {
    Write-Host "✗ Failed to start ThreatMap" -ForegroundColor Red
    exit 1
}

# Start Compliance Platform
Write-Host ""
Write-Host "2. Starting Compliance Platform..." -ForegroundColor Magenta
Set-Location $COMPLIANCE_DIR
& docker-compose down 2>$null
& docker-compose up -d
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Compliance Platform containers started" -ForegroundColor Green
    if (-not (Wait-ForService -Port 5500 -Name "Compliance Platform")) {
        exit 1
    }
} else {
    Write-Host "✗ Failed to start Compliance Platform" -ForegroundColor Red
    exit 1
}

# Start Master Nginx Gateway
Write-Host ""
Write-Host "3. Starting Master Nginx Gateway..." -ForegroundColor Magenta
Set-Location $NGINX_DIR
& docker-compose down 2>$null
& docker-compose up -d
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Master Nginx Gateway started" -ForegroundColor Green
    if (-not (Wait-ForService -Port 80 -Name "Master Nginx Gateway")) {
        exit 1
    }
} else {
    Write-Host "✗ Failed to start Master Nginx Gateway" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== All Services Started Successfully! ===" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Access your applications:" -ForegroundColor Cyan
Write-Host "   Main Gateway:    http://localhost/" -ForegroundColor White
Write-Host "   ThreatMap:       http://localhost/threatmap" -ForegroundColor White
Write-Host "   Compliance:      http://localhost/compliance" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Service URLs (direct access):" -ForegroundColor Cyan
Write-Host "   ThreatMap:       http://localhost:5544" -ForegroundColor White
Write-Host "   Compliance:      http://localhost:5500" -ForegroundColor White
Write-Host ""
Write-Host "📊 Health Checks:" -ForegroundColor Cyan
Write-Host "   Gateway Health:  http://localhost/health" -ForegroundColor White
Write-Host "   ThreatMap:       http://localhost:5544/health" -ForegroundColor White
Write-Host "   Compliance:      http://localhost:5500/health" -ForegroundColor White
Write-Host ""
Write-Host "Use 'docker-compose logs -f' in each directory to view logs" -ForegroundColor Yellow
Write-Host "Use '.\stop-all.ps1' to stop all services" -ForegroundColor Yellow
