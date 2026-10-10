#!/usr/bin/env bash

set -u

LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/network-check.log"

mkdir -p "$LOG_DIR"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Validate host argument
if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $0 <hostname-or-ip> [port]"
    exit 2
fi

host="$1"
port="${2:-}"

# Validate port if supplied
if [[ -n "$port" ]]; then
    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        echo "Error: port must be a number from 1 to 65535."
        log "Invalid port: $port"
        exit 2
    fi

    if (( port < 1 || port > 65535 )); then
        echo "Error: port must be between 1 and 65535."
        log "Port out of range: $port"
        exit 2
    fi
fi

echo "======================================"
echo "         NETWORK DIAGNOSTIC"
echo "======================================"
echo "Host: $host"

# Resolve host
resolved_address=""

if command -v getent >/dev/null 2>&1; then
    resolved_address=$(getent hosts "$host" 2>/dev/null | awk 'NR==1 {print $1}')
else
    resolved_address=$(dscacheutil -q host -a name "$host" 2>/dev/null \
        | awk '/^ip_address:/ {print $2; exit}')
fi

if [[ -z "$resolved_address" ]]; then
    echo "Error: unable to resolve host: $host"
    log "Host resolution failed: $host"
    exit 1
fi

echo "Resolved Address: $resolved_address"

# Basic connectivity check
echo
echo "Connectivity Check:"

if command -v ping >/dev/null 2>&1; then
    if ping -c 1 -W 2 "$host" >/dev/null 2>&1; then
        echo "Status: Reachable"
        log "Host reachable: $host ($resolved_address)"
        connectivity_status=0
    else
        echo "Status: Unreachable"
        log "Host unreachable: $host ($resolved_address)"
        connectivity_status=1
    fi
else
    echo "Status: ping command unavailable"
    connectivity_status=1
fi

# Network interface information
echo
echo "Network Interfaces:"

if command -v ip >/dev/null 2>&1; then
    ip addr
elif command -v ifconfig >/dev/null 2>&1; then
    ifconfig
else
    echo "Network interface information unavailable."
fi

# TCP port check
if [[ -n "$port" ]]; then
    echo
    echo "TCP Port Check: $host:$port"

    if command -v nc >/dev/null 2>&1; then
        if nc -z -w 3 "$host" "$port" >/dev/null 2>&1; then
            echo "TCP Status: OPEN"
            log "TCP port open: $host:$port"
        else
            echo "TCP Status: CLOSED or UNREACHABLE"
            log "TCP port closed/unreachable: $host:$port"
            connectivity_status=1
        fi
    else
        echo "TCP check unavailable: netcat (nc) is not installed."
        log "TCP check unavailable because nc is not installed."
    fi
fi

echo
echo "======================================"

log "Network diagnostic completed for $host"

exit "$connectivity_status"
