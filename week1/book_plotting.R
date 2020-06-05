library(tidyverse)
library(lubridate)
library(scales)
install.packages(c("mpg", "gapminder", "Lahman"))

mpg <- data.frame(ggplot2::mpg)
print.data.frame(mpg)

ggplot(data = mpg) + 
  geom_line(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_point(aes(x = displ, y = hwy, alpha = class))

#3.3.1
#1. What’s gone wrong with this code? Why are the points not blue?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
# Blue was put inside of the aes, but the should be outside describing all of the points:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

#2. Which variables in mpg are categorical? Which variables are continuous? (Hint: type ?mpg to read the documentation for the dataset). How can you see this information when you run mpg?
?mpg
# Categorical: Manufacturer name, model name, type of transmission, drv, fuel type, type of car
# Continuous: Display, year, city, highway
# If the values of the row is numerical, it's contunuous. Otherwise it is categorical

#3. Map a continuous variable to color, size, and shape. How do these aesthetics behave differently for categorical vs. continuous variables?
ggplot(data = mpg) + 
  geom_point(aes(x = trans, y = hwy, alpha = class)) #this tries plotting names in alphabetical order

ggplot(data = mpg) + 
  geom_point(aes(x = displ, y = hwy, alpha = class)) #this plots by the display number

#3.5.1
#1. What happens if you facet on a continuous variable?
#Each value will get its own subplot 

#4. What are the advantages to using faceting instead of the colour aesthetic? What are the disadvantages? How might the balance change if you had a larger dataset?
# Advantage of facet: You can get a thorough analysis of each value in the row you're analyzing
# Disadvantage of facet: You cannot closely compare each value of the row like you could if they were plotted in different colors on the same plot. 
# For a large data set, it may be wise to use both color and facets, perhaps by showing every year in a subplot and putting the variable you're analyzing in color in each subplot. 

#3.6.1
#5. Will these look different?
# Yes. To put the plot points and line in one graph, mapping should only be specified once

# 6. Recreate the R code necessary to generate the following graphs.
mpg %>% 
  ggplot(aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv)) +
  geom_point(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_smooth(mapping = aes(x = displ, y = hwy)) 

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv)) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = "white", stroke = 3))+
  geom_point(mapping = aes(x = displ, y = hwy, color = drv)) 
  

# 3.8.1
#1. What's wrong with this graph?
# It's not clear what the significance of the trend is. Adding colors and keys would help. 

#2. What parameters to geom_jitter() control the amount of jittering?
# By specifying width and height, the user can accoutn for varying amounts of jitter in the x or y directiom
