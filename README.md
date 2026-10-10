# Assignment 1 - Local System Diagnostic Toolkit

A Bash-based diagnostic toolkit for collecting system information, checking disk usage, and testing network connectivity on a local machine.

## Project Overview

This project contains three command-line diagnostic scripts:

- `system-info.sh` - displays basic system information.
- `disk-check.sh` - checks disk usage against a configurable threshold.
- `network-check.sh` - checks hostname resolution, connectivity, network interfaces, and optional TCP ports.

The scripts are designed to provide useful diagnostic information while returning meaningful exit codes and recording important events in log files.

## Requirements

- macOS or Linux
- Bash
- Git
- Standard Unix command-line utilities

## Project Structure

```text
assignment-1/
├── system-info.sh
├── disk-check.sh
├── network-check.sh
├── grade.sh
├── README.md
└── logs/
    ├── .gitkeep
    ├── system-info.log
    ├── disk-check.log
    └── network-check.log

## Making Scripts Executable
    chmod +x system-info.sh
    chmod +x disk-check.sh
    chmod +x network-check.sh
    chmod +x grade.sh

Usage: ./system-info.sh

The script displays information such as:
- Hostname
- Current user
- Date and time
- Operating system
- Kernel version
- Uptime
- CPU information
- Memory information
- Current working directory
Exammple:
========================================
          SYSTEM INFORMATION
========================================
Hostname: my-computer.local
User: user
Operating System: Darwin
Kernel: 24.6.0

The script writes a timestamped entry to: logs/system-info.log

Disk Usage Check
Run with the default threshold: ./disk-check.sh
Run with a custom threshold: ./disk-check.sh 90
Run with a custom threshold and path: ./disk-check.sh 80 /

The threshold is an integer between 1 and 100.

Invalid threshold input returns exit code 2.
Disk check results are recorded in: logs/disk-check.log

Network Diagnostic
I Run: ./network-check.sh localhost

Run with a TCP port: ./network-check.sh localhost 80

The script checks:
- Hostname or IP address
- Hostname resolution
- Connectivity
- Network interfaces
- Optional TCP port availability
The port must be between 1 and 65535.

Invalid examples:
./network-check.sh localhost 0
./network-check.sh localhost 65536
./network-check.sh localhost abc

Invalid port input returns exit code 2.
Network results are recorded in:
logs/network-check.log

Exit Codes
The scripts use exit codes to communicate results.
0 - Successful execution
1 - Diagnostic check failed or warning condition
2 - Invalid usage or input

Logging
Diagnostic events are recorded in the logs/ directory.
Log files include timestamps and relevant information about script execution.
The following files are used:
logs/system-info.log
logs/disk-check.log
logs/network-check.log

Testing
Check Bash syntax:
bash -n system-info.sh
bash -n disk-check.sh
bash -n network-check.sh

Run the scripts manually using the examples above.
The project also includes the supplied local grading script:
./grade.sh

Git Workflow
Development was completed using Git with multiple focused commits.
The project also uses a feature branch for documentation and grading improvements before merging changes back into main.
Platform Notes
The diagnostic commands use standard Unix/macOS utilities where available.
Some commands may produce different output on Linux and macOS because operating-system utilities are not identical.
Author:
Chidinma Florence Amaobi
Junior Backend Developer
