#!/usr/bin/env bash
# macOS-compatible network bandwidth monitor for tmux Dracula theme

INTERVAL="1"  # update interval in seconds

# Get network interface from tmux option, default to en0
network_name=$(tmux show-option -gqv "@dracula-network-bandwidth")
if [ -z "$network_name" ]; then
    # Auto-detect primary interface
    network_name=$(route -n get default 2>/dev/null | grep interface | awk '{print $2}')
    if [ -z "$network_name" ]; then
        network_name="en0"
    fi
fi

get_bytes() {
    # Get network statistics for the interface
    # netstat output columns: Name Mtu Network Address Ipkts Ierrs Ibytes Opkts Oerrs Obytes Coll
    # We want columns 7 (Ibytes) and 10 (Obytes)
    netstat -ibn | grep -E "^${network_name}\s" | head -1 | awk '{print $7, $10}'
}

format_bytes() {
    local bytes=$1
    local output=""
    local unit=""

    if [ $bytes -gt 1073741824 ]; then
        output=$(echo "$bytes 1024" | awk '{printf "%.2f", $1/($2 * $2 * $2)}')
        unit="gB/s"
    elif [ $bytes -gt 1048576 ]; then
        output=$(echo "$bytes 1024" | awk '{printf "%.2f", $1/($2 * $2)}')
        unit="mB/s"
    else
        output=$(echo "$bytes 1024" | awk '{printf "%.2f", $1/$2}')
        unit="kB/s"
    fi

    echo "$output $unit"
}

main() {
    while true; do
        # Get initial bytes
        read initial_download initial_upload <<< $(get_bytes)

        # Handle case where interface doesn't exist or no data
        if [ -z "$initial_download" ] || [ -z "$initial_upload" ]; then
            echo "↓ N/A • ↑ N/A"
            sleep $INTERVAL
            continue
        fi

        sleep $INTERVAL

        # Get final bytes
        read final_download final_upload <<< $(get_bytes)

        # Handle case where interface doesn't exist or no data
        if [ -z "$final_download" ] || [ -z "$final_upload" ]; then
            echo "↓ N/A • ↑ N/A"
            continue
        fi

        # Calculate bytes per second
        total_download_bps=$((final_download - initial_download))
        total_upload_bps=$((final_upload - initial_upload))

        # Handle negative values (can happen during interface reset)
        if [ $total_download_bps -lt 0 ]; then
            total_download_bps=0
        fi
        if [ $total_upload_bps -lt 0 ]; then
            total_upload_bps=0
        fi

        # Format the output
        download_formatted=$(format_bytes $total_download_bps)
        upload_formatted=$(format_bytes $total_upload_bps)

        echo "↓ $download_formatted • ↑ $upload_formatted"
    done
}

main
