#!/usr/bin/env bash

set -u

LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/system-info.log"

mkdir -p "$LOG_DIR"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

echo "======================================"
echo "        SYSTEM INFORMATION"
echo "======================================"

echo "Hostname: $(hostname)"
echo "User: $(whoami)"
echo "Date/Time: $(date)"
echo "Operating System: $(uname -s)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime)"
echo "CPU Information:"
uname -m
echo "CPU Cores: $(getconf _NPROCESSORS_ONLN 2>/dev/null || echo "Unknown")"

echo "Memory Information:"
if command -v free >/dev/null 2>&1; then
    free -h
else
    echo "Memory information command 'free' is not available."
fi

echo "Current Working Directory: $(pwd)"

echo "======================================"

log "System information collected successfully."
