#!/bin/bash

while true
do
    echo "===================================="
    echo "      LINUX MINI TASK MANAGER        "
    echo "===================================="
    echo "1. List Running Processes"
    echo "2. Show CPU & Memory Usage"
    echo "3. Kill a Process"
    echo "4. File Permission Check"
    echo "5. Exit"
    echo "===================================="
    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo "PID     COMMAND"
            echo "---------------------"
            ps -e -o pid,comm
            ;;
        2)
            echo "CPU Usage"
            top -bn1 | grep "Cpu(s)"
            echo
            echo "Memory Usage"
            free -h
            ;;
        3)
            read -p "Enter PID to kill: " pid
            kill -9 $pid && echo "Process killed" || echo "Failed to kill process"
            ;;
        4)
            read -p "Enter file name: " file
            if [ -e "$file" ]; then
                ls -l "$file"
            else
                echo "File not found"
            fi
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac

    echo
    read -p "Press Enter to continue..."
    clear
done
