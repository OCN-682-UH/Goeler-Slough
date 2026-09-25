### Week 5 class code, data wrangling: joins & dates with lubridate
### Created by Natalie Goeler-Slough
### Created on 2026-09-22

### loading libraries
library(tidyverse)
library(here)


###creating sample tibbles to practice joins
T1 <- tibble(
  Site.ID = c("A","B","C","D"),
  Temperature = c(14.1, 16.7, 15.3, 12.8)
)
T1

T2 <- tibble(
  Site.ID = c("A","B","D","E"),
  pH = c(7.3, 7.8, 8.1, 7.9)
)
T2

left_join(T1, T2) #keeps rows from left (first) dataframe, adds matching rows from the right
right_join(T1,T2) #keeps rows from right (second) dataframe, adds matching rows from the left
inner_join(T1, T2) #keeps only rows that exist in both dataframes (essentially dropping NAs)
full_join(T1,T2) #keeps all rows from both dataframes, with NA filling in missing values
semi_join(T1, T2) #keeps rows from 1st dataframe where there are matches in 2nd, but only returns columns from 1st
anti_join(T1, T2) #returns rows in first dataframe that do not match the 2nd (helpful for finding missing data)

#what if use different column names?
T3 <- tibble(
  SiteID = c("A","B","C","D"),
  Chlorophyll = c(2.3, 3.1, 1.9, 2.8)
)
left_join(T1, T3, by = c("Site.ID" = "SiteID")) #use by argument to specify column mapping as a named vector

#when matching requires multiple columns, specify all of them
T4 <- tibble(
  Site.ID = c("A", "A", "B", "B"),
  Year = c(2020, 2021, 2020, 2021),
  Biomass = c(12.5, 15.3, 18.2, 16.9)
)
T4

T5 <- tibble(
  SiteID = c("A", "A", "B"),
  Year = c(2020, 2021, 2021),
  Nutrients = c(8.2, 7.9, 9.1)
)
T5

left_join(T4, T5, by = c("Site.ID" = "SiteID", "Year" = "Year"))

#what happens when both have columns w/ same name but not joining by them?
T6 <- tibble(
  Site.ID = c("A", "B", "C"),
  Notes = c("pristine", "degraded", "moderately impaired")
)

T7 <- tibble(
  Site.ID = c("A", "B", "D"),
  Notes = c("sunny", "shaded", "partially shaded"),
  Quality = c("good", "fair", "poor")
)

# doesn't specify how to join — creates ambiguity with 'Notes' columns
left_join(T6, T7, by = "Site.ID")

#best practice = rename columns first, before joining
T6_renamed <- T6 |> 
  rename(Condition_Notes = Notes)

T7_renamed <- T7 |> 
  rename(Habitat_Notes = Notes)

left_join(T6_renamed, T7_renamed, by = "Site.ID")



### dates & times with lubridate
now() #what time is it now
now(tzone = "EST") #east coast time at this moment
today() #just the date today
am(now()) #is it morning now?
leap_year(now()) #is it a leap year 

#converting dates
ymd("2021-02-24")
mdy("2/24/21")

mdy_hm("2/24/2021 10:22 PM")

datetimes <- c( #create vector of datetimes
  "02/24/2021 22:22:20",
  "02/25/2021 11:21:10",
  "02/26/2021 8:01:52"
)
datetimes

datetimes <- mdy_hms(datetimes) #has to be in true date-time format for plotting chronologically
datetimes

month(datetimes) #extracting the month as a number
month(datetimes, label = TRUE) #extracting the month as an abbreviated label (automatically does factor)
month(datetimes, label = TRUE, abbr = FALSE) #extracting the month as a full label (automatically does factor)
day(datetimes) #extract day of the month
wday(datetimes, label = TRUE) #extract day of the week
hour(datetimes) #extract hour
minute(datetimes) #extract minute
second(datetimes) #extract second

datetimes + hours(4) #manipulating datetimes, adding time intervals
datetimes + hours(-4) #manipulating datetimes, subtracting time intervals
datetimes + days(2) #adding 2 days
datetimes + months(1) #adding 1 month

round_date(datetimes, "minute") #rounding dates, round to the nearest minute
round_date(datetimes, "5 mins") #rounding dates, round to the nearest 5 minutes
round_date(datetimes, "day") #rounding dates, round to the nearest day

datetime_naive <- mdy_hms("02/24/2021 10:22:20")
datetime_naive

#with_tz = view same moment in different timezone
hawaii_time <- with_tz(datetime_naive, tzone = "US/Hawaii")
hawaii_time

est_time <- with_tz(hawaii_time, tzone = "EST")
est_time

#Use force_tz() to reassign a naive datetime to a specific timezone (claim it was collected there)
force_hawaii <- force_tz(datetime_naive, tzone = "US/Hawaii")
force_hawaii

with_tz(force_hawaii, tzone = "EST") #now convert to EST -- changes the clock time


###reading in conductivity data
conddata <- read_csv(here("Week_5", "Data", "CondData.csv"))
head(conddata)

#converting date to datetime using pipe
conddata <- conddata |>
  mutate(datetime = mdy_hms(date))
conddata


# loading data
site_charac <- read_csv(here("Week_5", "Data", "site.characteristics.data.csv"))
site_charac
topt <- read_csv(here("Week_5", "Data", "Topt_data.csv"))

#make site characteristics wide and then join 
sites_wide <- site_charac |>
  pivot_wider(names_from = parameter.measured, values_from = values)

sites_topt <- full_join(sites_wide, topt)