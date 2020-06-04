install.packages(c("nycflights13", "gapminder", "Lahman"))
library(tidyverse)

# Tamar Yastrab

flights <- data.frame(nycflights13::flights)

# Find flight that:

#Had an arrival delay of two or more hours
flights %>% filter(arr_delay > 2)

#Flew to Houston (IAH or HOU)
flights %>%  filter(dest %in% c("IAH","HOU"))

#Were operated by United, American, or Delta
# There is no field for this?

#Departed in summer (July, August, and September)
flights %>%  filter(month %in% c(7, 8, 9))

#Arrived more than two hours late, but didn’t leave late
flights %>% filter(arr_delay > 2 & dep_delay == 0)

#Were delayed by at least an hour, but made up over 30 minutes in flight
flights %>% filter(dep_delay > 1 & arr_delay < -30)

#Departed between midnight and 6am (inclusive) ??
flights %>% filter(between(dep_time, 000, 600))

# How many flights have a missing dep_time? What other variables are missing? What might these rows represent?
flights %>% filter(is.na(dep_time)) 
# these flights have scheduled time but no recorded departure and arrival, and some are even 
# missing planes. These are probably the cancelled flights. 

#Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?
flights %>% mutate(total = arr_time - dep_time) %>% select(arr_time, dep_time, total, air_time)
# They should be the same, but they aren't because subtraction is treating the times as integers, not hours and minutes. 
# TO fix this, I would need to convert the hours and minutes into times. 

#What time of day should you fly if you want to avoid delays as much as possible?
flights %>% group_by(hour) %>% summarize(delays = mean(arr_delay, na.rm = TRUE)) %>% arrange((delays)) %>% head(5)