import sched
import time

# Create a scheduler object
scheduler = sched.scheduler()

def run_task():
    # Put your task code here
    print("Task running...")

# Schedule the task to run every hour
scheduler.enter(3600, 1, run_task)

# Run the scheduler
scheduler.run()
