#!/bin/bash

LOG_FILE="process_kill.log"

# Cache file for process list (optimization)
PROCESS_CACHE="/tmp/taskmanager_process_cache_$$"

# Function to cache process list
cache_processes() {
    ps -e -o pid,comm > "$PROCESS_CACHE"
}

# Cleanup cache on exit
trap "rm -f $PROCESS_CACHE" EXIT

while true
do
    clear
    echo "===================================="
    echo "   LINUX MINI TASK MANAGER (Optimized)"
    echo "===================================="
    echo "1. List Running Processes"
    echo "2. Show CPU & Memory Usage (Linux/Ubuntu)"
    echo "3. Kill a Process (linked with 1)"
    echo "4. File Permission Check"
    echo "5. Search Process by Name (linked with 1)"
    echo "6. Show Disk Usage"
    echo "7. Exit"
    echo "===================================="
    echo "Note: Options 1, 3, 5 share process data"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo
            echo "[Option 1: List Processes - Cached for options 3 & 5]"
            echo
            echo "PID     COMMAND"
            echo "---------------------"
            ps -e -o pid,comm | head -30
            
            # Cache for later use
            cache_processes
            
            total=$(ps -e | wc -l)
            echo ""
            echo "Showing first 30 of $((total-1)) total processes"
            echo "(Process list cached for options 3 and 5)"
            ;;
        
        2)
            echo
            echo "[Option 2: System Resources - Linux/Ubuntu Compatible]"
            echo
            echo "System Information:"
            echo "-------------------"
            echo "OS: $(uname -s) $(uname -r)"
            echo "Hostname: $(hostname)"
            echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
            echo
            
            echo "=== CPU Information ==="
            if [ -f /proc/cpuinfo ]; then
                cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)
                cpu_cores=$(grep -c processor /proc/cpuinfo)
                echo "CPU: $cpu_model"
                echo "Cores: $cpu_cores"
            fi
            
            echo
            echo "=== CPU Usage ==="
            top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "CPU Usage: " 100 - $1 "%"}'
            
            echo
            echo "=== Memory Usage ==="
            free -h
            
            echo
            echo "=== Top Processes by CPU ==="
            ps aux --sort=-%cpu | head -6 | awk '{printf "%-8s %-6s %-6s %s\n", $1, $2, $3, $11}'
            
            echo
            read -p "Launch htop for detailed view? (y/n): " launch_htop
            if [[ $launch_htop == "y" ]] && command -v htop &> /dev/null; then
                htop
            elif [[ $launch_htop == "y" ]]; then
                echo "htop not installed. Install with: sudo apt install htop"
            fi
            ;;
        
        3)
            echo
            echo "[Option 3: Kill Process - Linked with Option 1]"
            echo
            
            # Use cached process list if available
            if [ -f "$PROCESS_CACHE" ]; then
                echo "Using cached process list from Option 1:"
                echo "PID     COMMAND"
                echo "---------------------"
                cat "$PROCESS_CACHE" | head -20
            else
                echo "Loading current processes (run Option 1 first for faster loading):"
                echo "PID     COMMAND"
                echo "---------------------"
                ps -e -o pid,comm | head -20
                cache_processes
            fi
            
            echo
            read -p "Enter PID to kill from above list: " pid

            if [[ $pid =~ ^[0-9]+$ ]]; then
                # Get process name before killing
                pname=$(ps -p $pid -o comm=)
                
                if kill $pid 2>/dev/null; then
                    echo "Process $pid ($pname) killed successfully."

                    # Log killed process
                    echo "$(date) | User: $(whoami) | PID: $pid | Process: $pname" >> $LOG_FILE
                else
                    echo "Failed to kill process. Permission denied or PID not found."
                fi
            else
                echo "Invalid PID. Enter a numeric value."
            fi
            ;;
        
        4)
            echo
            echo "[Option 4: File Permission Check]"
            echo
            echo "Current Directory: $(pwd)"
            echo
            echo "--- Directory Contents ---"
            echo "Directories:"
            ls -d */ 2>/dev/null | head -10 | while read dir; do
                echo "  📁 $dir"
            done
            
            echo
            echo "Files:"
            ls -p | grep -v / | head -10 | while read file; do
                size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "?")
                echo "  📄 $file ($size bytes)"
            done
            
            echo
            read -p "Enter file/directory name or path: " file
            
            if [ -z "$file" ]; then
                echo "No file specified."
            elif [ -e "$file" ]; then
                echo
                echo "Detailed information for: $file"
                echo "----------------------------"
                ls -lh "$file"
                echo
                
                if [ -d "$file" ]; then
                    echo "Type: Directory"
                elif [ -f "$file" ]; then
                    echo "Type: Regular File"
                fi
                
                echo "Permissions breakdown:"
                stat "$file" 2>/dev/null || echo "(stat command unavailable)"
            else
                echo "✗ File or directory not found: $file"
            fi
            ;;
        
        5)
            echo
            echo "[Option 5: Search Process - Linked with Option 1]"
            echo
            
            # Use cached process list if available
            if [ -f "$PROCESS_CACHE" ]; then
                echo "Using cached process list from Option 1"
                total_cached=$(wc -l < "$PROCESS_CACHE")
                echo "(Cached: $total_cached processes)"
            else
                echo "Loading process list (run Option 1 first for faster loading)..."
                cache_processes
            fi
            
            echo
            read -p "Enter process name to search: " pname
            
            if [ -z "$pname" ]; then
                echo "No search term provided."
            else
                echo
                echo "Search results for '$pname':"
                echo "PID     COMMAND"
                echo "---------------------"
                
                if [ -f "$PROCESS_CACHE" ]; then
                    results=$(grep -i "$pname" "$PROCESS_CACHE" | grep -v grep)
                else
                    results=$(ps -e -o pid,comm | grep -i "$pname" | grep -v grep)
                fi
                
                if [ -z "$results" ]; then
                    echo "No processes found matching '$pname'"
                else
                    echo "$results"
                    count=$(echo "$results" | wc -l)
                    echo
                    echo "Found $count matching process(es)"
                    
                    # Option to kill from search results
                    echo
                    read -p "Kill a process from results? (y/n): " kill_choice
                    if [[ $kill_choice == "y" ]]; then
                        read -p "Enter PID to kill: " kill_pid
                        if [[ $kill_pid =~ ^[0-9]+$ ]]; then
                            pname=$(ps -p $kill_pid -o comm= 2>/dev/null)
                            read -p "Confirm kill PID $kill_pid ($pname)? (y/n): " confirm
                            if [[ $confirm == "y" ]]; then
                                if kill $kill_pid 2>/dev/null; then
                                    echo "✓ Process $kill_pid ($pname) killed successfully."
                                    echo "$(date) | User: $(whoami) | PID: $kill_pid | Process: $pname" >> $LOG_FILE
                                    # Refresh cache
                                    cache_processes
                                else
                                    echo "✗ Failed to kill process. Permission denied or PID not found."
                                fi
                            fi
                        else
                            echo "Invalid PID."
                        fi
                    fi
                fi
            fi
            ;;
        
        6)
            echo
            echo "Disk Usage:"
            df -h
            ;;
        
        7)
            echo "Exiting Task Manager..."
            exit 0
            ;;
        
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac

    echo
    read -p "Press Enter to continue..."
done