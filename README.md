# Windows Security Audit Script (PowerShell)

A comprehensive Windows system audit script written in PowerShell. This tool collects key security-related information to help assess the system’s security posture — including admin accounts, open ports, firewall status, antivirus info, login events, and system specs.

⚠️ Note: This script requires Administrator privileges and may be blocked by PowerShell's execution policy. See "How to Run" for instructions.

---

## Features

- Logs detailed system info (OS, RAM, CPU)
- Lists all local administrator accounts
- Checks Windows Firewall status
- Detects installed antivirus products
- Retrieves recent successful login events
- Scans open TCP ports and maps them to processes
- Outputs all data to timestamped log files in a logs/ folder
- Uses #requires -RunAsAdministrator to enforce elevation before execution

---

## Project Structure

windows_audit/
├── windows_audit.ps1         # Main script
├── logs/                     # Automatically created for output
│   └── audit_YYYYMMDD_HHMM.txt
└── README.md

---

## Example Output Snippet

--- Windows System Audit ---
Date: 6/27/2025 3:32:15 PM
Computer Name: WIN10-PC
OS Version: Microsoft Windows 11 Pro 10.0.22621
CPU: Intel(R) Core(TM) i7-8700 CPU @ 3.20GHz
RAM: 15.93 GB

--- Local Administrator Accounts ---
Admin: WIN10-PC\AdminUser (User)
Admin: WIN10-PC\Administrator (User)

--- Firewall Status ---
Domain: Enabled
Private: Enabled
Public: Enabled

--- Antivirus Status ---
AV: Microsoft Defender Antivirus - Status: 397568

--- Recent Successful Logins ---
[2025-06-27 14:33:02] Login by: JohnDoe from IP: 192.168.1.5
[2025-06-27 13:00:12] Login by: SYSTEM from IP: -

--- Open TCP Ports ---
Port 135 (PID: 992) - svchost
Port 445 (PID: 4) - System
Port 3389 (PID: 1056) - TermService

---

## How to Run

✅ This script requires Administrator privileges. If not elevated, it will not run and display a clear error.

### Option 1: Run via PowerShell (Admin)

1. Open PowerShell as Administrator
2. Execute the script:

    .\windows_audit.ps1

❗ If you see a "running scripts is disabled" error, use the bypass method below.

---

### Option 2: Bypass Execution Policy (One-Time Use)

If your system blocks scripts by default, run this instead from PowerShell (Admin):

    powershell -ExecutionPolicy Bypass -File "C:\Path\To\windows_audit.ps1"

This will temporarily override restrictions and run the script normally.

---

## Use Cases

- Blue team system checks
- Compliance audits
- Educational demonstrations of Windows security features
- Penetration testing: Validate what’s visible to an attacker

---

## Requirements

- Windows 10 or 11
- PowerShell 5.1 or later
- Must be run as Administrator

---

## Portfolio Value

This project demonstrates:
- Real-world scripting and automation
- Blue team / defensive cybersecurity knowledge
- Familiarity with Windows internals and system monitoring
- Ability to produce useful tools with readable logs
- Awareness of PowerShell security practices (#requires, execution policy, elevation)

---

## Disclaimer

This tool is for educational and internal auditing purposes only. Do not run it on machines you do not own or have permission to audit.

---

## Author

Kareem Habboub  
📧 kareemhabbo@gmail.com
