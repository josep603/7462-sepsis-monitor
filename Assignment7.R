
#Task1 Setup

library(tidyverse)
library(data.table) ## For the fread function
library(lubridate)

source("sepsis_monitor_functions.R")

#Task 2: Speed reading
library(tictoc)

#Time for time taken to create sepsis data set with 50 Patients using Fread
tic()
makeSepsisDataset(n=50,read_fn = "fread")
toc()

#Time for time taken to create sepsis data set with 100 Patients using Fread
tic()
makeSepsisDataset(n=100,read_fn = "fread")
toc()

#Time for time taken to create sepsis data set with 500 Patients using Fread
tic()
makeSepsisDataset(n=500,read_fn = "fread")
toc()


#Time for time taken to create sepsis data set with 50 Patients using read_delim

tic()
suppressMessages({

makeSepsisDataset(50, "read_delim")
})
toc()

#Time for time taken to create sepsis data set with 100 Patients using read_delim
tic()
suppressMessages({

makeSepsisDataset(100, "read_delim")
})
toc()


#Time for time taken to create sepsis data set with 500 Patients using read_delim

tic()
suppressMessages({
  
makeSepsisDataset(500, "read_delim")
})
toc()


#Task #3: Upload to Google Drive

library(googledrive)

df <- makeSepsisDataset()

# We have to write the file to disk first, then upload it
df %>% write_csv("sepsis_data_temp.csv")

# Uploading happens here
sepsis_file <- drive_put(media = "sepsis_data_temp.csv", 
                         path = "https://drive.google.com/drive/folders/1-m-NusLPgw-uFXAD-fuRxiyYymI3159m",
                         name = "sepsis_data.csv")

# Set the file permissions so anyone can download this file.
sepsis_file %>% drive_share_anyone()


#Task 4

## Calling drive_deauth() prevents R from trying to authenticate via a browser
## This is needed to make the GitHub Action work
drive_deauth()

file_link <- "https://drive.google.com/file/d/1bloQHuPsZIhTZTnqeYkj15W_gSmKtHOd"

## All data up until now
new_data <- updateData(file_link)

## Include only most recent data
most_recent_data <- new_data %>%
  group_by(PatientID) %>%
  filter(obsTime == max(obsTime))


