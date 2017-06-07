# load files and put them in the "Data" directory
download.file(url = c("http://docs.google.com/spreadsheet/pub?key=phAwcNAVuyj0TAlJeCEzcGQ&output=xlsx", 
                      "http://docs.google.com/spreadsheet/pub?key=phAwcNAVuyj0NpF2PTov2Cw&output=xlsx"), 
              destfile = c("Data/indicator undata total_fertility.xlsx", 
                           "Data/indicator gapminder infant_mortality.xlsx"))

library("readxl")
raw_fert <-read_excel(path="Data/indicator undata total_fertility.xlsx",sheet="Data")
raw_infantMort <- read_excel(path="Data/indicator gapminder infant_mortality.xlsx")

# on windows, this method does not work, go on gapminder website and download them manually, save them in the right directory

#frame manipulation
# data frame has cells, with columns and rows
# values in the cells; 
#values  associated with observations (unit we mearsure) and variables 
# variables are all the values, were observed and has an ID which describes the variables)
# but somtimes the data comes in other format, wide format, long format
# wide: each row is a site/patient
# wide format easy to check for human
# ID, a1, a2, a3
# xx, xx, xx, xx
# long format easy to read for computer
#  reorganize the data in column
# long: only 1 observation variable

# format: purely wide, purely long or tidy?
gapminder
# 3 variables (pop, lifeExp, gdpPerCap) => is not long format
# is in tidy format
#
# fertility data
# wide format
# put it in the tidy format
raw_fert

# change from wide to long format = geant column
fert <- raw_fert %>%
rename(country=`Total fertility rate`)%>%
  gather(key=year, value=fert)
  
  gather(key=year, value=fert, - country)



fert <- raw_fert %>%
  rename(country=`Total fertility rate`)%>%
  gather(key=year, value=fert, - country) %>%
  mutate(year=as.integer(year))


# GAPMINDER PLUS 
download.file(url = "https://raw.githubusercontent.com/dmi3kno/SWC-tidyverse/master/data/gapminder_plus.csv", 
              destfile = "Data/gapminder_plus.csv")

gapminder_plus<-read_csv(file="Data/gapminder_plus.csv")

head(gapminder_plus)

#last value of the highest
# data : filter them
# countries which has over 2000 depth
# unit: nb of baby are in ratio
#  1) mutate get a new column with nb of baby dead in the country
# 2) in 2007:
#7 countries Africa
# join data set to the main gap_minder


countries_many_deadBaby <- gapminder_plus %>%
  mutate(baby_dead=infantMort*pop/10^9)%>%
  filter(year==2007)%>%
  filter(continent=="Africa")%>%
  filter(baby_dead>2)%>%
  select(country)

list_interest<-left_join(countries_many_deadBaby, gapminder_plus, by="country") %>%
mutate(baby_dead=infantMort*pop/10^3)

# join
# inner join will select records which are matching between 2 dataset, data which are present in both sets
# full join: all the variables
# left_joint: retain all the countries which are in the left list, and we sacrify all the other countries
# join keep all the colums (add them next to eachother), if same names of colums then we get name.x and name.y
# by="country: optional here since there is only 1 column)
# could use inner join since all the countries are in both list


list_interest%>%
  select(year)%>% # give columns of years
gather(key=variables, value=smthg)  # years are put in the column "something", and year is repeated in the "variables"
# gather changes the format

list_interest%>%
  select(year, country)%>% # give columns of years
  gather(key=variables, value=smthg) %>% View()  # years ou

list_interest%>%
  gather(key=variables, value=smthg, c(fert,infantMort, baby_dead)) %>% View() 

# or instead of writting all the list of variables in c, we just excluse what we don't want
list_interest%>%
  gather(key=variables, value=smthg, -c(country, year))



# use of the dot '.' as argument: place the result of the pipe at the . place
#could say: ggplot(mapping=aes() blablbl, data=.)
# by default, first argument is data=.


gapminder_plus%>%
  filter(continent=="Africa", year==2007) %>%
  mutate(babiesDead=infantMort*pop/10^9)%>%
  filter(babiesDead>2)%>%
  select(country) %>%
  left_join(gapminder_plus) %>%
  mutate(babiesDead=infantMort*pop/10^3,
         gdp_bln=gdpPercap*pop/1e9,
         pop_mln=pop/1e6) %>%
  select(-c(continent, pop, babiesDead)) %>%
  gather(key=variables, value=values, -c(country, year))%>%
  ggplot()+
  geom_text(data=. %>%
              filter(year==2007) %>% group_by(variables) %>%
              mutate(max_value=max(values))%>%
              filter(values==max_value),
aes(x=year, y=values, color=country, label=country))+
  geom_line(mapping=aes(x=year, y=values, color=country))+
  facet_wrap(~variables, scales="free_y")+ # by default the scale is all the same for all the graphs
  labs(title='Key parameters for selected African countries', 
       subtitle='with over 2 mil. baby death  in 2007',
       caption='cccc',
       y=NULL,
       x="Year"+
         theme_bw()+ #theme_classic()# change the apparenceof the graph, many themes available
         theme(legend.position="none")) # modify something that you don't like in the theme


# use of the dot '.' as argument: place the result of the pipe at the . place
#could say: ggplot(mapping=aes() blablbl, data=.)
# by default, first argument is data=.








#  group_by(continent,year)%>%
#  summarize(mean_gdp_billion=mean(gdp_billion))%>%
#  head()
