## main pipeline control script

print("PROCESS: START")

# Authenticate
source("R/10-auth.R")

# Process Data
source("R/20-process-data.R")

print("PROCESS: END")
