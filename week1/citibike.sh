#!/bin/bash
# Tamar Yastrab

# count the number of unique stations
cat 201402-citibike-tripdata.csv | cut -d , -f 4 | sort | uniq | wc -l
# count the number of unique bikes
cat 201402-citibike-tripdata.csv | cut -d , -f 12 | sort | uniq | wc -l
# count the number of trips per day
cat 201402-citibike-tripdata.csv | cut -d , -f 2 | cut -d ' ' -f 1 | uniq -c
# find the day with the most rides
cat 201402-citibike-tripdata.csv | cut -d , -f 2 | cut -d ' ' -f 1 | uniq -c | sort -r | head -n 1
# find the day with the fewest rides
cat 201402-citibike-tripdata.csv | cut -d , -f 2 | cut -d ' ' -f 1 | uniq -c | sort | head -n 2 | tail -n 1
# find the id of the bike with the most rides
cat 201402-citibike-tripdata.csv | cut -d , -f 12 | sort | uniq -c | sort -r | head -n 1
# count the number of rides by gender and birth year
cat 201403-citibike-tripdata.csv | cut -d , -f 14,15 | tr '"' ' ' | sort -k 2 | uniq -c
# count the number of trips that start o cross streets that both contain numbers (e.g., "1 Ave & E 15 St", "E 39 St & 2 Ave", ...)
cat 201402-citibike-tripdata.csv | cut -d , -f 5 | egrep [0-9].* [0-9] | wc -l

# compute the average trip duration 
cat 201402-citibike-tripdata.csv | cut -d ',' -f 1 | tr -d '"' | awk '{duration += $0; counter++} END {print duration/counter}'

