<powershell>
# ============================================================================
# EC2 Module - Example User Data Script for Windows
# ============================================================================
# This script runs when Windows EC2 instances start up
# Copy this to your root directory as user_data.ps1
# Reference in terraform.tfvars: user_data_base64 = base64encode(file("${path.module}/user_data.ps1"))

# Enable detailed logging
Start-Transcript -Path "C:\ProgramData\user-data.log" -Append

Write-Host "=========================================="
Write-Host "Starting Windows EC2 Instance Initialization"
Write-Host "Hostname: $($env:COMPUTERNAME)"
Write-Host "=========================================="

# Set error action preference
$ErrorActionPreference = "Stop"

try {
    # Update system
    Write-Host "Updating Windows..."
    Install-WindowsUpdate -AcceptAll -AutoReboot:$false
    
    # Set execution policy for current user
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    
    # Install Chocolatey (Package Manager)
    Write-Host "Installing Chocolatey..."
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    # Install applications via Chocolatey
    Write-Host "Installing applications..."
    choco install -y `
        git `
        docker-desktop `
        vscode `
        7zip `
        curl `
        wget
    
    # Configure Windows Firewall (Example)
    Write-Host "Configuring Windows Firewall..."
    # New-NetFirewallRule -DisplayName "Allow Docker" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 2375,2376 -RemoteAddress Any
    
    # Enable Remote Desktop (Optional)
    Write-Host "Enabling Remote Desktop..."
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0
    
    # Create application directory
    $appPath = "C:\Application"
    if (-not (Test-Path $appPath)) {
        New-Item -ItemType Directory -Path $appPath -Force | Out-Null
        Write-Host "Created application directory: $appPath"
    }
    
    # Example: Clone repository (uncomment and customize)
    # Write-Host "Cloning application repository..."
    # cd $appPath
    # git clone https://github.com/your-repo/your-app.git .
    
    # Set environment variables (Example)
    # [Environment]::SetEnvironmentVariable("APP_ENV", "production", "Machine")
    
    # Create status file
    "Initialization complete!" | Out-File -FilePath "C:\ProgramData\user-data-complete" -Encoding ASCII
    
    Write-Host "=========================================="
    Write-Host "Windows EC2 Instance Initialization Finished"
    Write-Host "=========================================="
    
} catch {
    Write-Host "ERROR: $_"
    Write-Host $_.Exception.Message
    exit 1
}

Stop-Transcript
</powershell>
