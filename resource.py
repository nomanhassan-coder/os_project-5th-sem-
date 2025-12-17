import psutil

def show_cpu_memory_usage():
    cpu = psutil.cpu_percent(interval=1)
    mem = psutil.virtual_memory()

    print("\n CPU Usage")
    print(f"Total CPU Usage: {cpu}%")

    print("\n Memory Usage")
    print(f"Total Memory: {mem.total / (1024**3):.2f} GB")
    print(f"Used Memory: {mem.used / (1024**3):.2f} GB")
    print(f"Available Memory: {mem.available / (1024**3):.2f} GB")

