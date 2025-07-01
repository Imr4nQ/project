# Load packages
library(tidyverse)
library(lubridate)
library(janitor)

# Load the data
bike_data <- read_csv("cyclistic_tripdata_cleaned.csv")

# Clean column names
bike_data <- clean_names(bike_data)

# Create ride_length column
bike_data <- bike_data %>%
  mutate(ride_length = as.numeric(difftime(ended_at, started_at, units = "mins")),
         day_of_week = wday(started_at, label = TRUE))

# Remove negative durations
bike_data <- filter(bike_data, ride_length > 0)


# Summary stats
summary(bike_data$ride_length)

# Avg ride time by user type
bike_data %>%
  group_by(member_casual) %>%
  summarise(avg_ride = mean(ride_length),
            median_ride = median(ride_length),
            max_ride = max(ride_length),
            number_of_rides = n())

# Avg ride time by user type and day
bike_data %>%
  group_by(member_casual, day_of_week) %>%
  summarise(avg_duration = mean(ride_length)) %>%
  arrange(member_casual, day_of_week)


# Plot: Number of rides by user type and day
bike_data %>%
  group_by(member_casual, day_of_week) %>%
  summarise(number_of_rides = n()) %>%
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Number of Rides by Rider Type & Day")

# Plot: Average ride duration by type and day
bike_data %>%
  group_by(member_casual, day_of_week) %>%
  summarise(avg_duration = mean(ride_length)) %>%
  ggplot(aes(x = day_of_week, y = avg_duration, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Avg Ride Duration by Rider Type & Day")

install.packages("tinytex")
tinytex::install_tinytex()



