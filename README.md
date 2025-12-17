# Python Mini Task Manager

A simple Python application to monitor and manage system processes, CPU, and memory usage.

## Features
- **List Running Processes** - View currently running processes on your system
- **Show CPU & Memory Usage** - Monitor CPU and RAM usage in real-time
- **Kill Process** - Terminate a process by its PID with confirmation

## Prerequisites
- Python 3.6 or higher
- pip (Python package manager)

## Installation Steps

### Step 1: Install Python
Make sure Python is installed on your system. Check by running:
```bash
python --version
```

### Step 2: Install Required Package (psutil)
The project requires the `psutil` library. Install it using:
```bash
pip install psutil
```

Or with elevated privileges (if needed):
```bash
sudo pip install psutil
```

### Step 3: Navigate to Project Directory
```bash
cd /path/to/mini_task_manager
```

## Running the Project

### Start the Application
```bash
python main.py
```

### Menu Options
Once running, you'll see the main menu:

```
1. List Processes
   - Shows first 15 running processes with their PIDs

2. Show CPU & Memory
   - Displays CPU usage percentage
   - Shows total, used, and free memory
   - Visual progress bars for usage levels

3. Kill Process
   - Enter a process PID to terminate
   - Requires confirmation before killing
   
4. Exit
   - Closes the application
```

### Example Usage

**List Processes:**
```
Enter choice (1-4): 1
PID       PROCESS NAME
...
```

**Check System Resources:**
```
Enter choice (1-4): 2
--- CPU Usage ---
CPU: 25% [#####               ]

--- Memory Usage ---
Total:     7.81 GB
Used:      3.45 GB (44%)
Free:      4.36 GB
```

**Kill a Process:**
```
Enter choice (1-4): 3
Enter PID: 1234
Kill PID 1234? (y/n): y
✓ Killed 'process_name' (PID: 1234)
```

## Troubleshooting

### "ModuleNotFoundError: No module named 'psutil'"
Solution: Install psutil
```bash
pip install psutil
```

### "Permission denied" when killing process
Solution: Run with elevated privileges
```bash
sudo python main.py
```

### Process not found error
Make sure you enter a valid PID. Use option 1 to list all processes first.

## Files
- `main.py` - Main application and menu
- `process.py` - Process listing and killing functions
- `resource.py` - CPU and memory monitoring functions
- `README.md` - This file

## Notes
- The application runs in a loop until you choose "Exit"
- Press Ctrl+C to force exit at any time
- Some processes may require admin/sudo privileges to kill
