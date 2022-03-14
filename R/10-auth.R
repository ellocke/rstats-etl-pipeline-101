## Authentication Script

print("PROCESS: AUTH STAGE")

system(command = "echo 'Authenticating with Google Sheets'")

googlesheets4::gs4_deauth() # prevent interactive auth

googlesheets4::gs4_auth(
  path = Sys.getenv("TOKEN") # grab Token from Environment Variable
)
