#!/bin/bash

# Find all .txt files in the current directory that are older than 14 days
# and delete them
find . -mtime +14 -name "*.txt" -delete



#!/bin/bash

# Find all files in the current directory that are older than 14 days
# and delete them
find . -mtime +14 -delete


#!/bin/bash

# Find all files in the current directory that are older than 14 days
# and delete them
find . -mtime +14 -exec rm {} \;


#!/bin/bash

# Find all .txt files in the current directory that are older than 2 days
# and delete them
find . -mtime +2 -name "*.txt" -delete


#!/bin/bash

# Find all files in the current directory that are older than 2 days
# and delete them
find . -mtime +2 -delete


#!/bin/bash

# Find all files in the current directory that are older than 2 days
# and delete them
find . -mtime +2 -exec rm {} \;
