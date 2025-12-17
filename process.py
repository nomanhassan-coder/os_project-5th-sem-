import psutil
import os
import signal

def list_processes():
    print("\nPID\tPROCESS NAME")
    print("--------------------------")
    for proc in psutil.process_iter(['pid', 'name']):
        try:
            print(f"{proc.info['pid']}\t{proc.info['name']}")
        except psutil.NoSuchProcess:
            pass


def kill_process(pid):
    try:
        os.kill(pid, signal.SIGKILL)
        print(f"Process {pid} killed successfully")
    except PermissionError:
        print("Permission denied")
    except ProcessLookupError:
        print("Process not found")
