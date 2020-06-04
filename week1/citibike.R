library(tidyverse)
library(lubridate)

########################################
# READ AND TRANSFORM THE DATA
########################################

# read one month of data
trips <- read_csv('201402-citibike-tripdata.csv')

# replace spaces in column names with underscores
names(trips) <- gsub(' ', '_', names(trips))

# convert dates strings to dates
# trips <- mutate(trips, starttime = mdy_hms(starttime), stoptime = mdy_hms(stoptime))

# recode gender as a factor 0->"Unknown", 1->"Male", 2->"Female"
trips <- mutate(trips, gender = factor(gender, levels=c(0,1,2), labels = c("Unknown","Male","Female")))


########################################
# YOUR SOLUTIONS BELOW
########################################

# count the number of trips (= rows in the data frame)
trips %>% summarize(count = n())

# find the earliest and latest birth years (see help for max and min to deal with NAs)
trips %>% filter(birth_year != "\\N") %>% summarize(minYear=min(birth_year), maxYear=max(birth_year)) 

# use filter and grepl to find all trips that either start or end on broadway
trips %>% filter(grepl("Broadway", start_station_name) | grepl("Broadway", end_station_name))

# do the same, but find all trips that both start and end on broadway
trips %>% filter(grepl("Broadway", start_station_name) & grepl("Broadway", end_station_name))

# find all unique station names
trips %>% group_by(start_station_name) %>% summarize()

# count the number of trips by gender, the average trip time by gender, and the standard deviation in trip time by gender
# do this all at once, by using summarize() with multiple arguments
trips %>% group_by(gender) %>% summarize(count = n(),
                                      mean_trip_time = mean(tripduration) / 60,
                                      sd_trip_time = sd(tripduration)/60)


# find the 10 most frequent station-to-station trips
# are we supposed to use head? Should we count and then filter again?
trips %>% group_by(start_station_name, end_station_name) %>% summarize(count=n()) %>% arrange(desc(count)) %>% head(10)

# find the top 3 end stations for trips starting from each start station
trips %>% group_by(start_station_name, end_station_name) %>% summarize(count=n()) %>% arrange(desc(count)) %>% slice(1:3)
#slice is better than select because it will calculate by row instead of creating rank col

# find the top 3 most common station-to-station trips by gender
most <- group_by(trips, start_station_name, end_station_name, gender) %>% summarize(count=n()) %>% arrange(desc(count))

most %>%
  group_by(gender) %>%
  arrange(desc(count)) %>%
  mutate(start = row_number()) %>%
  filter(start <= 3) %>% 
  arrange(gender)

# find the day with the most trips
# tip: first add a column for year/month/day without time of day (use as.Date or floor_date from the lubridate package)
trips %>% mutate(startday = as.Date(starttime)) %>% group_by(startday) %>% summarize(count = n()) %>% arrange(desc(count)) %>% head(1)


# compute the average number of trips taken during each of the 24 hours of the day across the entire month
# what time(s) of day tend to be peak hour(s)?
trips %>% mutate(startday = floor_date(starttime, "hour")) %>% group_by(hour(startday)) %>% summarize(average = n()/28) %>% arrange(desc(average)) 
