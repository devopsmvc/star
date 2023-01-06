import os
import time

# Set the directory where the files are located
directory = '.'

# Get the current time in seconds
current_time = time.time()

# Loop through all files in the directory
for file in os.listdir(directory):
    # Get the modification time of the file in seconds
    file_time = os.path.getmtime(file)
    # Calculate the difference between the current time and the
    # modification time of the file, in days
    time_diff = (current_time - file_time) / (24 * 3600)
    # If the difference is more than 2 days, delete the file
    if time_diff > 2:
        os.remove(file)
