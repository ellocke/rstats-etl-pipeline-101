## Load [{poorman}](https://github.com/nathaneastwood/poorman) package instead of {tidyverse}

## Data Processing Script

print("PROCESS: DATA STAGE")

# Extract

system(command = "echo 'STATUS: Extracting Data from Spreadsheet'")

sheetID <- Sys.getenv(x = "SHEETID") #grab sheet ID from Environment Variable
import_data <- googlesheets4::read_sheet(ss = sheetID, sheet = "mtcars")

system(command = paste0("echo ",
                        paste0("STATUS: imported Data length: ",
                               nrow(import_data))))

# Transform

system(command = "echo 'STATUS: Transforming Imported Data'")

library(poorman)
## cf. https://github.com/nathaneastwood/poorman
## {poorman} has it's own implementation of the `%>%` pipe
## but let's use the new R-base pipe `|>` (R 4.1.0)
## FIY: the `unexpected token` RStudio error has been fixed
## in the RStudio 1.4 Preview
## Update: the {poorman} Docker image runs on R 4.0.0 
## and therefore doesn't support `|>` yet.

export_data <- import_data %>% # TBD: |>
  group_by(cyl) %>% # TBD: |>
  summarise(mean = mean(hp))

print(export_data)

# Load

system(command = "echo 'STATUS: Loading Result into Spreadsheet'")

googlesheets4::write_sheet(export_data,
                           ss = sheetID,
                           sheet = "averages")

system(command = "echo 'STATUS: Pipeline Successful!'")
