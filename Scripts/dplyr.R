library(tidyverse)
gapmider <- read_csv(file="Data/gapminder-FiveYearData.csv")
# wrong spelling remove this data
rm(gapmider)
gapminder <- read_csv(file="Data/gapminder-FiveYearData.csv")

#repeat function: arg1: what to repeat, arg 2: how many time to repeat it
rep("This is an example", times=3)

#Using pipe with %>% symbol 
"This is an example" %>% rep(times=3)

# restrict our dataframe to only 3 columns
year_country_gdp <- select(gapminder, year, country, gdpPercap)
head(year_country_gdp) # tail to see the end
# data frame maniuplation with dplyr

# DOing the same but using a pipe command

year_country_gdp <- gapminder %>% select(year, country, gdpPercap)


gapminder %>% filter(year==2002) %>% 
  ggplot(mapping=aes(x=continent, y=pop))+
 geom_boxplot()

year_country_gdp_euro <- gapminder %>%
  filter(continent=="Europe") %>%
select(year, country, gdpPercap)

# write a single command which can span multiple lines and include a pipe,
#that will produce a dataframe that has the Norwegian walues
# for gdpPercap, lifeExp and year
#How many rows does your data frame have and why?

country_lifeExp_Norway <- gapminder %>%
  filter(country=="Norway") %>%
  select(gdpPercap,lifeExp,year)
  
# creat groups
gapminder %>%
  group_by(continent)


# compute the average gdpPercap for each groups (here: each continent)
gapminder %>%
  group_by(continent) %>%
  summarize(A_name=mean(gdpPercap)) 
#name of column will be A_name
# but this is not a variable

# compute the average gdpPercap for each groups (here: each continent)
gapminder %>%
  group_by(continent) %>%
  summarize(mean(gdpPercap))
# no name of the column, just the type

# plot the average in function of continent
gapminder %>%
  group_by(continent) %>%
  summarize(mean_gdpPercap=mean(gdpPercap))%>%
  ggplot(mapping=aes(x=continent,y=mean_gdpPercap))+
  geom_point()


# challenge calc the average life Exp per country in Asia
# which has longest/shortest lifeExp?

# do it graphycally
gapminder %>%
  filter(continent=="Asia") %>%
  group_by(country) %>%
  summarize(mean_lifeExp=mean(lifeExp)) %>%
  ggplot(mapping=aes(x=country,y=mean_lifeExp))+
  geom_point()+
  coord_flip()
# not practical to see the minimal/max if many values are close
# or use sort/order
# using min/max function:
minmaxsave <-gapminder %>%
  filter(continent=="Asia") %>%
  group_by(country) %>%
  summarize(mean_lifeExp=mean(lifeExp)) %>%
  filter(mean_lifeExp==min(mean_lifeExp)|mean_lifeExp==max(mean_lifeExp))
  
 # create a new variable from the column:
# $ sign means that
data <-mean(gapminder$lifeExp)

# function mutate, transform one variable to another one, add a column
gapminder %>%
  mutate(gdp_billion=gdpPercap*pop/10^9)

# function summarize, calculte statistics across the dataset
gapminder %>%
  mutate(gdp_billion=gdpPercap*pop/10^9)%>%
  group_by(continent,year)%>%
  summarize(mean_gdp_billion=mean(gdp_billion))%>%
  head()

#input of what we will plot just after with the map plotting cmd
gapminder_country_summary <- gapminder %>%
  group_by(country)%>%
summarize(mean_lifeExp=mean(lifeExp))


#install.packages("maps")
# contain the information about country coordinates
library(maps)
map_data("world")%>%
  head()

map_data("world")%>%
  rename(country=region)%>% #rename the "region" column into "country"
  left_join(gapminder_country_summary,by="country")%>% 
  # joining by country: 
  # country in gapminder_country will be joined to "country" in map_data
  ggplot()+
  geom_polygon(aes(x=long,y=lat, group=group,fill=mean_lifeExp))+
 scale_fill_gradient(low="blue", high="red")+
coord_equal()


map_data("world")%>%
  rename(country=region)%>% #rename the "region" column into "country"
  left_join(gapminder_country_summary)%>%
  ggplot()+
  geom_polygon(aes(x=long,y=lat, group=group,fill=mean_lifeExp))+
  scale_fill_gradient(low="blue", high="red")+
  coord_equal()

# while are some countries grey?
# some countries are not named the same in both data_frames
worldmap<- map_data("world")
setdiff(worldmap$region,gapminder$country)
# elemets in x but not in y
