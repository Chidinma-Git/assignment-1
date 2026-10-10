#!/usr/bin/env bash

set -u

LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/disk-check.log"

mkdir -p "$LOG_DIR"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Check threshold argument
if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $0 <threshold> [path]"
    exit 2
fi

threshold="$1"
path="${2:-/}"

# Validate threshold
if ! [[ "$threshold" =~ ^[0-9]+$ ]]; then
    echo "Error: threshold must be an integer from 1 to 100."
    log "Invalid threshold: $threshold"
    exit 2
fi

if (( threshold < 1 || threshold > 100 )); then
    echo "Error: threshold must be between 1 and 100."
    log "Threshold out of range: $threshold"
    exit 2
fi

# Validate path
if [[ ! -d "$path" ]]; then
    echo "Error: path does not exist or is not a directory: $path"
    log "Invalid path: $path"
    exit 2
fi

# Get disk usage percentage
usage=$(df -P "$path" | awk 'NR==2 {gsub("%","",$5); print $5}')

if [[ -z "$usage" ]]; then
    echo "Error: unable to determine disk usage."
    log "Failed to determine disk usage for $path"
    exit 1
fi

echo "======================================"
echo "           DISK USAGE CHECK"
echo "======================================"
echo "Path: $path"
echo "Disk Usage: ${usage}%"
echo "Threshold: ${threshold}%"
echo "======================================"

if (( usage >= threshold )); then
    echo "WARNING: Disk usage has reached or exceeded the threshold."
    log "Disk usage ${usage}% reached/exceeded threshold ${threshold}% for $path"
    exit 1
else
    echo "OK: Disk usage is below the threshold."
    log "Disk usage ${usage}% is below threshold ${threshold}% for $path"
    exit 0
fi