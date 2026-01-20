import psutil
import os

# Cache for process list to avoid multiple iterations
_process_cache = []
_cache_timestamp = 0

def get_all_processes(force_refresh=False):
    """Get all running processes with caching for optimization"""
    global _process_cache, _cache_timestamp
    import time
    
    current_time = time.time()
    # Refresh cache if older than 2 seconds or forced
    if force_refresh or (current_time - _cache_timestamp) > 2:
        _process_cache = []
        for proc in psutil.process_iter(['pid', 'name']):
            try:
                _process_cache.append({
                    'pid': proc.info['pid'],
                    'name': proc.info['name']
                })
            except:
                pass
        _cache_timestamp = current_time
    
    return _process_cache

def list_processes(limit=15, show_all=False):
    """List running processes with optional limit"""
    processes = get_all_processes(force_refresh=True)
    
    print("\nPID       PROCESS NAME")
    print("-" * 40)
    
    display_count = len(processes) if show_all else min(limit, len(processes))
    
    for i in range(display_count):
        proc = processes[i]
        print(f"{proc['pid']:<10} {proc['name']}")
    
    print(f"\nShowing {display_count} of {len(processes)} processes")
    return processes


def kill_process(pid):
    """Kill a process by its PID"""
    try:
        # Find the process
        proc = psutil.Process(pid)
        proc_name = proc.name()
        
        # Kill it
        proc.kill()
        print(f"✓ Killed '{proc_name}' (PID: {pid})")
        
        # Refresh cache after killing
        get_all_processes(force_refresh=True)
        
    except psutil.NoSuchProcess:
        print(f"✗ Process {pid} not found")
    except psutil.AccessDenied:
        print(f"✗ No permission (try: sudo python main.py)")
    except:
        print(f"✗ Could not kill process {pid}")


def search_process(search_name):
    """Search for processes by name using cached data"""
    processes = get_all_processes()
    
    print(f"\nSearching for processes matching '{search_name}'...")
    print("\nPID       PROCESS NAME")
    print("-" * 40)
    
    matches = []
    for proc in processes:
        if search_name.lower() in proc['name'].lower():
            matches.append(proc)
            print(f"{proc['pid']:<10} {proc['name']}")
    
    if len(matches) == 0:
        print(f"No processes found matching '{search_name}'")
    else:
        print(f"\nFound {len(matches)} matching process(es)")
    
    return matches