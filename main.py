from process import list_processes, kill_process, search_process, get_all_processes
from resource import show_cpu_memory_usage
import os

def show_menu():
    """Display menu options"""
    print("\n" + "=" * 40)
    print("   PYTHON MINI TASK MANAGER")
    print("=" * 40)
    print("1. List All Processes")
    print("2. Show CPU & Memory Usage")
    print("3. Kill Process")
    print("4. File Permission Check")
    print("5. Search Process")
    print("6. Exit")
    print("=" * 40)

def list_current_directory():
    """List files in current directory for option 4"""
    print("\n--- Current Directory Contents ---")
    try:
        cwd = os.getcwd()
        print(f"Location: {cwd}\n")
        
        items = os.listdir(cwd)
        dirs = [d for d in items if os.path.isdir(d)]
        files = [f for f in items if os.path.isfile(f)]
        
        if dirs:
            print("Directories:")
            for d in sorted(dirs)[:10]:
                print(f"  📁 {d}/")
        
        if files:
            print("\nFiles:")
            for f in sorted(files)[:10]:
                size = os.path.getsize(f)
                print(f"  📄 {f} ({size} bytes)")
        
        if len(items) > 20:
            print(f"\n... and {len(items)-20} more items")
            
    except Exception as e:
        print(f"Error listing directory: {e}")

# Main program
print("Welcome to Python Mini Task Manager!\n")
print("Options 1, 3, and 5 are linked for optimized process management.")

while True:
    show_menu()
    choice = input("\nEnter choice (1-6): ")

    if choice == "1":
        # List all running processes
        print("\n[Option 1: List Processes - Data cached for options 3 & 5]")
        list_processes(limit=20, show_all=False)

    elif choice == "2":
        # Show system resources
        print("\n[Option 2: System Resources]")
        show_cpu_memory_usage()

    elif choice == "3":
        # Kill a process (linked with option 1)
        print("\n[Option 3: Kill Process - Linked with Option 1]")
        
        # Use cached process list if available, otherwise show fresh list
        processes = get_all_processes()
        if not processes:
            list_processes(limit=20)
        else:
            print("\nUsing cached process list from Option 1:")
            print("\nPID       PROCESS NAME")
            print("-" * 40)
            for proc in processes[:20]:
                print(f"{proc['pid']:<10} {proc['name']}")
            print(f"\nShowing {min(20, len(processes))} of {len(processes)} processes")
        
        print()
        try:
            pid = int(input("Enter PID from above list: "))
            confirm = input(f"Kill PID {pid}? (y/n): ")
            if confirm.lower() == 'y':
                kill_process(pid)
        except ValueError:
            print("✗ Invalid input - Please enter a valid PID number")
        except KeyboardInterrupt:
            print("\n✗ Operation cancelled")

    elif choice == "4":
        # File Permission Check
        print("\n[Option 4: File Permission Check]")
        list_current_directory()
        print()
        
        filepath = input("Enter file/directory name or path: ").strip()
        if filepath:
            try:
                if os.path.exists(filepath):
                    stat_info = os.stat(filepath)
                    is_dir = os.path.isdir(filepath)
                    
                    print(f"\n{'Directory' if is_dir else 'File'}: {filepath}")
                    print(f"Size: {stat_info.st_size} bytes")
                    print(f"Permissions: {oct(stat_info.st_mode)[-3:]}")
                    print(f"Owner UID: {stat_info.st_uid}")
                    print(f"Group GID: {stat_info.st_gid}")
                    
                    # Readable permission breakdown
                    mode = stat_info.st_mode
                    perms = [
                        'r' if mode & 0o400 else '-',
                        'w' if mode & 0o200 else '-',
                        'x' if mode & 0o100 else '-',
                        'r' if mode & 0o040 else '-',
                        'w' if mode & 0o020 else '-',
                        'x' if mode & 0o010 else '-',
                        'r' if mode & 0o004 else '-',
                        'w' if mode & 0o002 else '-',
                        'x' if mode & 0o001 else '-',
                    ]
                    print(f"Permissions: {''.join(perms)} (Owner-Group-Others)")
                else:
                    print(f"✗ Path not found: {filepath}")
            except Exception as e:
                print(f"✗ Error checking permissions: {e}")
        else:
            print("✗ No file path provided")

    elif choice == "5":
        # Search for a process by name (linked with option 1)
       # print("\n - Linked with Option 1]")
        
        # Use cached process list if available
        processes = get_all_processes()
        if not processes:
            print("Refreshing process list...")
            list_processes(limit=20)
        else:
            print(f"Using cached data ({len(processes)} processes)")
        
        print()
        search_name = input("Enter process name to search: ").strip()
        if search_name:
            matches = search_process(search_name)
            
            # Offer to kill from search results
            if matches and len(matches) > 0:
                print()
                kill_choice = input("Kill a process from results? (y/n): ")
                if kill_choice.lower() == 'y':
                    try:
                        pid = int(input("Enter PID to kill: "))
                        confirm = input(f"Confirm kill PID {pid}? (y/n): ")
                        if confirm.lower() == 'y':
                            kill_process(pid)
                    except ValueError:
                        print("✗ Invalid PID")
        else:
            print("✗ No search term provided")

    elif choice == "6":
        # Exit program
        print("\nThank you for using Python Mini Task Manager!")
        print("Goodbye!")
        break

    else:
        print("✗ Invalid choice! Please enter 1-6")

