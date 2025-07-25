#requires -RunAsAdministrator

# Create logs directory if it doesn't exist
$logDir = ".\logs"
if (!(Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir | Out-Null
}

# Create timestamped log file
$timestamp = Get-Date -Format "yyyyMMdd_HHmm"
$logFile = "$logDir\audit_$timestamp.txt"

# Collect system info
$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$ram = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)

# Write system info to log
"--- Windows System Audit ---" | Out-File $logFile
"Date: $(Get-Date)" | Out-File $logFile -Append
"Computer Name: $($os.CSName)" | Out-File $logFile -Append
"OS Version: $($os.Caption) $($os.Version)" | Out-File $logFile -Append
"CPU: $($cpu.Name)" | Out-File $logFile -Append
"RAM: $ram GB" | Out-File $logFile -Append

# List admin accounts
"--- Local Administrator Accounts ---" | Out-File $logFile -Append

$admins = Get-LocalGroupMember -Group "Administrators" 2>$null
if ($admins) {
    foreach ($admin in $admins) {
        "Admin: $($admin.Name) ($($admin.ObjectClass))" | Out-File $logFile -Append
    }
} else {
    "WARNING: Could not retrieve administrator accounts. Try running as Administrator." | Out-File $logFile -Append
}

# Check Windows Firewall status
"--- Firewall Status ---" | Out-File $logFile -Append

try {
    $profiles = Get-NetFirewallProfile
    foreach ($profile in $profiles) {
        $status = if ($profile.Enabled) { "Enabled" } else { "Disabled ⚠️" }
        "$($profile.Name): $status" | Out-File $logFile -Append
    }
} catch {
    "Could not retrieve firewall status." | Out-File $logFile -Append
}
# Check Antivirus status
"--- Antivirus Status ---" | Out-File $logFile -Append

try {
    $avProducts = Get-CimInstance -Namespace "root\SecurityCenter2" -ClassName "AntivirusProduct"
    if ($avProducts) {
        foreach ($product in $avProducts) {
            "AV: $($product.displayName) - Status: $($product.productState)" | Out-File $logFile -Append
        }
    } else {
        "No antivirus products detected ⚠️" | Out-File $logFile -Append
    }
} catch {
    "Could not retrieve antivirus information. Try running as Administrator." | Out-File $logFile -Append
}

# Show recent successful logins
"--- Recent Successful Logins ---" | Out-File $logFile -Append

try {
    $events = Get-WinEvent -LogName Security -FilterHashtable @{Id=4624; StartTime=(Get-Date).AddDays(-2)} -MaxEvents 10
    foreach ($event in $events) {
        $xml = [xml]$event.ToXml()
        $account = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetUserName" } | Select-Object -ExpandProperty '#text'
        $ip = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "IpAddress" } | Select-Object -ExpandProperty '#text'
        $time = $event.TimeCreated
        "[$time] Login by: $account from IP: $ip" | Out-File $logFile -Append
    }
} catch {
    "Unable to access login events. Try running as Administrator." | Out-File $logFile -Append
}

# List open TCP ports and their associated processes
"--- Open TCP Ports ---" | Out-File $logFile -Append

try {
    $connections = Get-NetTCPConnection -State Listen | Sort-Object -Property LocalPort
    foreach ($conn in $connections) {
        $proc = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
        $procName = if ($proc) { $proc.ProcessName } else { "Unknown" }
        "Port $($conn.LocalPort) (PID: $($conn.OwningProcess)) - $procName" | Out-File $logFile -Append
    }
} catch {
    "Could not retrieve open ports." | Out-File $logFile -Append
}


Write-Output "✅ System info saved to $logFile"
