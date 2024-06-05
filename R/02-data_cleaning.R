library(tidyverse)
library(dplyr)
library(googlesheets4)

# Read the raw data from Google Sheets
waste_data <- read_csv("data/raw/waste-characterisation-raw.csv")

glimpse(waste_data)

# Convert 'Timestamp' to Date format YYYY-MM-DD
waste_data <- waste_data %>% 
  mutate(Timestamp = as.Date(Timestamp, format = "%m/%d/%Y %H:%M:%S"))

# Replace each blank cell with NA, excluding the 'Timestamp' column
waste_data <- waste_data %>% 
  mutate(across(-Timestamp, ~ifelse(. == "", NA, .)))

glimpse(waste_data)

# Changing the column names
waste_data <- waste_data %>% 
  rename(
    timestamp = Timestamp,
    age = `What is your age?`,
    living_in_zurich = `Are you currently living in Zurich City?`,
    primary_language = `What is your primary language?`,
    german_skills = `How good is your german language skills?`,
    study_level = `What level of study are you currently pursuing?`,
    field_of_study = `What is your field of study?`,
    knowledge_rating = `On a scale from 1 to 5, how would you rate your knowledge about Zurich's waste management system?`,
    recycle_frequency = `In your opinion, how often do you recycle your waste?`,
    system_effectiveness = `Do you think that Zurich's waste management system is effective?`,
    biggest_challenge = `What do you think is the biggest challenge for waste management in Zurich?`,
    improvement_suggestion = `Which of these would you suggest to make the biggest improvement to the waste management system in Zurich?`,
    future_info_interest = `Would you like to receive more information about waste management initiatives in Zurich in the future?`
  )

# Convert columns to appropriate data types
waste_data <- waste_data %>%
  mutate(
    primary_language = as.character(primary_language),
    study_level = as.character(study_level),
    field_of_study = as.character(field_of_study),
    age = factor(age),
    living_in_zurich = factor(living_in_zurich),
    recycle_frequency = factor(recycle_frequency),
    biggest_challenge = factor(biggest_challenge),
    improvement_suggestion = factor(improvement_suggestion),
    future_info_interest = factor(future_info_interest),
    german_skills = as.numeric(german_skills),
    knowledge_rating = as.numeric(knowledge_rating),
    system_effectiveness = as.numeric(system_effectiveness)
  )

glimpse(waste_data)

# Save the cleaned data
write_csv(waste_data, "data/processed/waste_survey.csv")
write_rds(waste_data, "data/processed/waste_survey.rds")

# Data Dictionary
data_dictionary <- tibble(
  ColumnName = names(waste_data),
  Description = c(
    "Timestamp of the response",
    "Age group of the respondent",
    "Current living status in Zurich City",
    "Primary language of the respondent",
    "German language proficiency",
    "Current level of study",
    "Field of study",
    "Self-rated knowledge about Zurich's waste management system",
    "Frequency of recycling",
    "Perception of the effectiveness of Zurich's waste management system",
    "Biggest challenge for waste management in Zurich",
    "Suggestion for the biggest improvement to Zurich's waste management system",
    "Interest in receiving more information about waste management initiatives in the future"
  ),
  DataType = sapply(waste_data, class)
)

# Save the data dictionary
write_csv(data_dictionary, "data/processed/data_dictionary.csv")
write_rds(data_dictionary, "data/processed/data_dictionary.rds")


# Classify students as Local Swiss or International
waste_data <- waste_data %>%
  mutate(student_group = if_else(primary_language %in% c("German", "French", "Italian", "Romansh") & living_in_zurich == "Yes", "Local Swiss", "International"))

# Clean data: Convert recycling frequency to a numerical scale for better analysis
waste_data <- waste_data %>%
  mutate(recycle_frequency_num = case_when(
    recycle_frequency == "Always" ~ 5,
    recycle_frequency == "Often" ~ 4,
    recycle_frequency == "Sometimes" ~ 3,
    recycle_frequency == "Rarely" ~ 2,
    recycle_frequency == "Never" ~ 1,
    TRUE ~ NA_real_
  ))

write_csv(waste_data, "data/final/waste_survey.csv")
write_rds(waste_data, "data/final/waste_survey.rds")
