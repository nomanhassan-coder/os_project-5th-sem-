import psutil
import platform

def show_cpu_memory_usage():
    """Show CPU and Memory usage - optimized for Linux/Ubuntu"""
    # System info
    print(f"\n{'='*40}")
    print(f"System: {platform.system()} {platform.release()}")
    print(f"{'='*40}")
    
    # Show CPU usage
    print("\n--- CPU Usage ---")
    cpu_percent = psutil.cpu_percent(interval=1, percpu=False)
    cpu_count = psutil.cpu_count(logical=True)
    cpu_freq = psutil.cpu_freq()
    
    print(f"CPU Cores:  {cpu_count}")
    if cpu_freq:
        print(f"CPU Freq:   {cpu_freq.current:.0f} MHz")
    print(f"CPU Usage:  {cpu_percent}% {make_bar(cpu_percent)}")
    
    # Per-core usage for detailed view
    per_cpu = psutil.cpu_percent(interval=0.1, percpu=True)
    print(f"\nPer-Core Usage:")
    for i, usage in enumerate(per_cpu[:4]):  # Show first 4 cores
        print(f"  Core {i}: {usage}% {make_bar(usage, width=10)}")
    if len(per_cpu) > 4:
        print(f"  ... and {len(per_cpu)-4} more cores")
    
    # Show Memory usage
    print("\n--- Memory Usage ---")
    mem = psutil.virtual_memory()
    swap = psutil.swap_memory()
    
    total_gb = mem.total / (1024**3)
    used_gb = mem.used / (1024**3)
    free_gb = mem.available / (1024**3)
    
    print(f"Total:     {total_gb:.2f} GB")
    print(f"Used:      {used_gb:.2f} GB ({mem.percent}%)")
    print(f"Available: {free_gb:.2f} GB")
    print(f"Usage:     {make_bar(mem.percent)}")
    
    # Swap info
    if swap.total > 0:
        swap_gb = swap.total / (1024**3)
        swap_used = swap.used / (1024**3)
        print(f"\nSwap:      {swap_used:.2f} / {swap_gb:.2f} GB ({swap.percent}%)")


def make_bar(percent, width=20):
    """Make a simple progress bar with configurable width"""
    filled = int(percent / (100 / width))
    bar = '#' * filled
    spaces = ' ' * (width - filled)
    return f"[{bar}{spaces}]"

