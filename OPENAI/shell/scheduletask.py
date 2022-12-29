import sched
import time

# Create a scheduler object
scheduler = sched.scheduler()

def run_task():
    # Put your task code here
    print("Task running...")

# Get the current time
now = time.time()

# Calculate the time in seconds until 10am on January 1, 2022
run_time = time.mktime(time.strptime("2022-01-01 10:00:00", "%Y-%m-%d %H:%M:%S"))

# Schedule the task to run at 10am on January 1, 2022
scheduler.enterabs(run_time, 1, run_task)

# Run the scheduler
scheduler.run()


