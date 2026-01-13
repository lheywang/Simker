Write-Host "=== Installing Simker for Windows ===" -ForegroundColor Cyan

$AppName = "simker"
$ImageName = "my_wrapper_tool:latest"
$ConfigDir = "$HOME\.config\$AppName"
$ProfilePath = $PROFILE

# 1. Build Docker Image
Write-Host "[1/3] Building Docker Image..." -ForegroundColor Cyan
docker build -t $ImageName .
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Docker build failed." -ForegroundColor Red
    exit
}

# 2. Setup Config Directory
Write-Host "[2/3] Setting up Config at $ConfigDir..." -ForegroundColor Cyan
if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Force -Path $ConfigDir | Out-Null
}
Copy-Item -Path "docker-compose.yml" -Destination "$ConfigDir\docker-compose.yml" -Force

# 3. Setup PowerShell Function
Write-Host "[3/3] Configuring PowerShell Profile..." -ForegroundColor Cyan

# Create Profile if it doesn't exist
if (-not (Test-Path $ProfilePath)) {
    New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
}

$FunctionCode = @"

# --- SIMKER START ---
function simker {
    `$env:PROJECT_DIR = Get-Location
    docker-compose -f "$ConfigDir\docker-compose.yml" run --rm tool `$args
}
# --- SIMKER END ---
"@

# Check if already installed
$CurrentProfile = Get-Content $ProfilePath -Raw -ErrorAction SilentlyContinue
if ($CurrentProfile -match "SIMKER START") {
    Write-Host "      Function already in profile. Skipping." -ForegroundColor Green
} else {
    Add-Content -Path $ProfilePath -Value $FunctionCode
    Write-Host "      Function added to $ProfilePath." -ForegroundColor Green
}

Write-Host "=== Installation Complete! ===" -ForegroundColor Cyan
Write-Host "Please restart your PowerShell terminal to use 'simker'."