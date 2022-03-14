## main pipeline controller

print("PROCESS: START")

# Authenticate
source("R/01-auth.R")

# Process Data
source("R/02-process-data.R")

print("PROCESS: END")
