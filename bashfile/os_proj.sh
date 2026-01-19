#!/bin/bash

LOG_FILE="process_kill.log"

while true
do
    clear
    echo "===================================="
    echo "      LINUX MINI TASK MANAGER        "
    echo "===================================="
    echo "1. List Running Processes"
    echo "2. Show CPU & Memory Usage"
    echo "3. Kill a Process"
    echo "4. File Permission Check"
    echo "5. Search Process by Name"
    echo "6. Show Disk Usage"
    echo "7. Exit"
    echo "===================================="

    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo
            echo "PID     COMMAND"
            echo "---------------------"
            ps -e -o pid,comm
            ;;
        
        2)
            echo
            if command -v htop &> /dev/null; then
                echo "Launching htop..."
                htop
            else
                echo "htop not found. Showing top output."
                top -bn1 | head -10
                echo
                free -h
            fi
            ;;
        
        3)
            echo
            read -p "Enter PID to kill: " pid

            if [[ $pid =~ ^[0-9]+$ ]]; then
                if kill $pid 2>/dev/null; then
                    echo "Process $pid killed successfully."

                    # Log killed process
                    echo "$(date) | User: $(whoami) | PID: $pid" >> $LOG_FILE
                else
                    echo "Failed to kill process. Permission denied or PID not found."
                fi
            else
                echo "Invalid PID. Enter a numeric value."
            fi
            ;;
        
        4)
            echo
            read -p "Enter file name or path: " file
            if [ -e "$file" ]; then
                ls -l "$file"
            else
                echo "File not found."
            fi
            ;;
        
        5)
            echo
            read -p "Enter process name to search: " pname
            echo "Search results:"
            ps -e | grep -i "$pname" | grep -v grep
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



















# #!/bin/bash

# while true
# do
#     echo "===================================="
#     echo "      LINUX MINI TASK MANAGER        "
#     echo "===================================="
#     echo "1. List Running Processes"
#     echo "2. Show CPU & Memory Usage"
#     echo "3. Kill a Process"
#     echo "4. File Permission Check"
#     echo "5. Exit"
#     echo "===================================="
#     read -p "Enter your choice: " choice

#     case $choice in
#         1)
#             echo "PID     COMMAND"
#             echo "---------------------"
#             ps -e -o pid,comm
#             ;;
#         2)
#             echo "CPU Usage"
#             top -bn1 | grep "Cpu(s)"
#             echo
#             echo "Memory Usage"
#             free -h
#             ;;
#         3)
#             read -p "Enter PID to kill: " pid
#             kill -9 $pid && echo "Process killed" || echo "Failed to kill process"
#             ;;
#         4)
#             read -p "Enter file name: " file
#             if [ -e "$file" ]; then
#                 ls -l "$file"
#             else
#                 echo "File not found"
#             fi
#             ;;
#         5)
#             echo "Exiting..."
#             exit 0
#             ;;
#         *)
#             echo "Invalid choice"
#             ;;
#     esac

#     echo
#     read -p "Press Enter to continue..."
#     clear
# done
