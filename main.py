from process import list_processes, kill_process
from resource import show_cpu_memory_usage

def show_menu():
    # Display menu options
    print("\n" + "=" * 40)
    print("   PYTHON MINI TASK MANAGER")
    print("=" * 40)
    print("1. List Processes")
    print("2. Show CPU & Memory")
    print("3. Kill Process")
    print("4. Exit")
    print("=" * 40)

# Main program
print("Welcome to Task Manager!\n")

while True:
    show_menu()
    choice = input("\nEnter choice (1-4): ")

    if choice == "1":
        # Show running processes
        list_processes()

    elif choice == "2":
        # Show system resources
        show_cpu_memory_usage()

    elif choice == "3":
        # Kill a process
        try:
            pid = int(input("Enter PID: "))
            confirm = input(f"Kill PID {pid}? (y/n): ")
            if confirm.lower() == 'y':
                kill_process(pid)
        except:
            print("✗ Invalid input")

    elif choice == "4":
        # Exit program
        print("\nGoodbye!")
        break

    else:
        print("✗ Invalid choice!")

