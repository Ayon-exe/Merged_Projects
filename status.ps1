# DeepCytes Application Gateway Status Check
# PowerShell version

Write-Host "=== DeepCytes Application Gateway Status ===" -ForegroundColor Cyan
Write-Host ""

# Function to check service status
function Test-ServiceStatus {
    param([int]$Port, [string]$Name, [string]$Url)
    
    Write-Host "Checking $Name..." -ForegroundColor Yellow
    try {
        $response = Invoke-WebRequest -Uri $Url -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "  ✓ $Name is HEALTHY (Port $Port)" -ForegroundColor Green
            return $true
        } else {
            Write-Host "  ✗ $Name returned status $($response.StatusCode)" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "  ✗ $Name is DOWN or UNREACHABLE (Port $Port)" -ForegroundColor Red
        Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor DarkRed
        return $false
    }
}

# Check all services
$services = @(
    @{ Name = "Master Gateway"; Port = 80; Url = "http://localhost/health" }
    @{ Name = "ThreatMap"; Port = 5544; Url = "http://localhost:5544/health" }
    @{ Name = "Compliance Platform"; Port = 5500; Url = "http://localhost:5500/health" }
)

$allHealthy = $true
foreach ($service in $services) {
    $status = Test-ServiceStatus -Port $service.Port -Name $service.Name -Url $service.Url
    if (-not $status) {
        $allHealthy = $false
    }
}

Write-Host ""
if ($allHealthy) {
    Write-Host "🟢 ALL SERVICES ARE HEALTHY!" -ForegroundColor Green
} else {
    Write-Host "🔴 SOME SERVICES ARE DOWN!" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Quick Access Links ===" -ForegroundColor Cyan
Write-Host "Gateway Home:     http://localhost/" -ForegroundColor White
Write-Host "ThreatMap:        http://localhost/threatmap" -ForegroundColor White
Write-Host "Compliance:       http://localhost/compliance" -ForegroundColor White
Write-Host ""
Write-Host "=== Docker Container Status ===" -ForegroundColor Cyan

# Check Docker containers
try {
    $containers = docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | Where-Object { $_ -match "threat-map|compliance|master-nginx" }
    if ($containers) {
        $containers | ForEach-Object { Write-Host $_ -ForegroundColor White }
    } else {
        Write-Host "No relevant containers found running" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Could not retrieve Docker container information" -ForegroundColor Red
}
