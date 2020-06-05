########################################
# load libraries
########################################

# load some packages that we'll need
library(tidyverse)
library(scales)

# be picky about white backgrounds on our plots
theme_set(theme_bw())

# load RData file output by load_trips.R
load('trips.RData')


########################################
# plot trip data
########################################

# plot the distribution of trip times across all rides (compare a histogram vs. a density plot)
trips %>% 
  filter(tripduration < 5e3) %>% 
  ggplot(aes(x = tripduration)) +
    geom_histogram()

trips %>% 
  filter(tripduration < 5e3) %>% 
  ggplot(aes(x = tripduration)) +
    geom_density()

# plot the distribution of trip times by rider type indicated using color and fill (compare a histogram vs. a density plot)
trips %>% 
  filter(tripduration < 5e3) %>% 
  ggplot(aes(x = tripduration, color = usertype, fill = usertype)) +
    geom_histogram(alpha = .25)
# finish with notes****

# plot the total number of trips on each day in the dataset
trips %>% 
  group_by(ymd) %>% 
  summarise(total_trips = n()) %>% 
  ggplot(aes(x = ymd, y = total_trips)) +
    geom_point()+
    xlab('Date') +
    ylab('Total Trips')

# plot the total number of trips (on the y axis) by age (on the x axis) and gender (indicated with color)
trips %>% 
  mutate(age = 2014 - birth_year) %>% 
  group_by(gender, age) %>% 
  summarize(birth_gender =n()) %>% 
  filter(birth_gender < 4e5) %>% 
  ggplot(aes(x = age, y = birth_gender, color = gender)) +
    geom_point() +
    scale_y_continuous(label = comma) +
    xlab('Age') +
    ylab('Total trips')

# plot the ratio of male to female trips (on the y axis) by age (on the x axis)
# hint: use the spread() function to reshape things to make it easier to compute this ratio
# (you can skip this and come back to it tomorrow if we haven't covered spread() yet)
trips %>% 
  mutate(age = 2014 - birth_year) %>% 
  group_by(gender, age) %>% 
  summarize(count = n()) %>% 
  select(age, gender, count) %>% 
  pivot_wider(names_from = "gender", values_from = "count") %>% 
  group_by(age) %>% 
  mutate(ratio = Male / Female) %>% 
  filter(age < 90.0) %>% 
  ggplot(aes(x = age, y = ratio)) +
    geom_point() +
    xlab("Male:Female Trips") +
    ylab("Age")
  

########################################
# plot weather data
########################################
# plot the minimum temperature (on the y axis) over each day (on the x axis)
weather %>% 
    ggplot(aes(x = ymd, y = tmin))+
      geom_point() +
      xlab('Date') +
      ylab('Minimum Temprature')

# plot the minimum temperature and maximum temperature (on the y axis, with different colors) over each day (on the x axis)
# hint: try using the gather() function for this to reshape things before plotting
# (you can skip this and come back to it tomorrow if we haven't covered gather() yet)
weather %>% 
  select(ymd, tmax, tmin) %>% 
  pivot_longer(names_to = "temprature", values_to = "degrees", c(2:3)) %>% 
  ggplot(aes(x = ymd, y = degrees, color = temprature)) +
    geom_point() +
    scale_y_continuous(label = comma) +
    xlab('Day') +
    ylab('Degrees (F)')

########################################
# plot trip and weather data
########################################

# join trips and weather
trips_with_weather <- inner_join(trips, weather, by="ymd")

# plot the number of trips as a function of the minimum temperature, where each point represents a day
# you'll need to summarize the trips and join to the weather data to do this
trips_with_weather %>% 
  group_by(ymd) %>% 
  summarise(count = n()) %>% 
  left_join(weather) %>% 
  ggplot(aes(x = tmin, y = count))+
    geom_point() +
    xlab('(Min) Temprature of the Day') +
    ylab('Number of Trips')
  

# repeat this, splitting results by whether there was substantial precipitation or not
# you'll need to decide what constitutes "substantial precipitation" and create a new T/F column to indicate this
trips_with_weather %>% 
  group_by(ymd) %>% 
  summarise(count = n()) %>% 
  left_join(weather) %>%
  mutate(precipitation = prcp > 0.05) %>% 
  ggplot(aes(x = tmin, y = count))+
    geom_point() +
    facet_wrap(~ precipitation)+
    xlab('(Min) Temprature of the Day') +
    ylab('Number of Trips') 
  
# add a smoothed fit on top of the previous plot, using geom_smooth
trips_with_weather %>% 
  group_by(ymd) %>% 
  summarise(count = n()) %>% 
  left_join(weather) %>%
  mutate(precipitation = prcp > 0.05) %>% 
  ggplot(aes(x = tmin, y = count))+
    geom_point() +
    geom_smooth(method = "lm") +
    facet_wrap(~ precipitation)+
    xlab('(Min) Temprature of the Day') +
    ylab('Number of Trips') 

# compute the average number of trips and standard deviation in number of trips by hour of the day
# hint: use the hour() function from the lubridate package
trips %>% 
  mutate(hour_of_day = floor_date(starttime, "hour")) %>% 
  group_by(hour(hour_of_day), ymd) %>% 
  summarize(count = n()) %>% 
  mutate(weekday = between(wday(ymd),2,6))


Hours %>% 
  group_by(`hour(hour_of_day)`) %>% 
  summarize(average = mean(count), 
            hour_sd = sd(count))
  
  
# plot the above

Hours %>% 
  group_by(`hour(hour_of_day)`) %>% 
  summarize(average = mean(count), 
            hour_sd = sd(count)) %>% 
  ggplot(aes(x = `hour(hour_of_day)`, y = average))+
    geom_point() + 
  xlab('Time of Day') +
  ylab('Average Trip Number')

# repeat this, but now split the results by day of the week (Monday, Tuesday, ...) or weekday vs. weekend days
# hint: use the wday() function from the lubridate package

Hours %>% 
  group_by(`hour(hour_of_day)`, weekday) %>% 
  summarize(average = mean(count), 
            hour_sd = sd(count)) %>% 
  ggplot(aes(x = `hour(hour_of_day)`, y = average))+
  geom_point() + 
  facet_wrap(~ weekday)+
  xlab('Time of Day') +
  ylab('Average Trip Number')





  
