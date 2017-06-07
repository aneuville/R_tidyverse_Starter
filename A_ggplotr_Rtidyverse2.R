#https://github.com/aneuville/SWC-tidyverse
# new project: from Github
# in github: 
#fork the project to your home git
# download the project
# copy the adress 
# (writen: clone with httpd, use GIT or checkout with SVN using the web URL)
# in R
# new project
# from version control
# paste the web adress
# install.packages("tidyverse")
library("tidyverse")

url1 <- "https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder-FiveYearData.csv"
url2 <- "https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_wide.csv"
dir.create(file.path("data"))
download.file(url1, "data/gapminder-FiveYearData.csv")
download.file(url2, "data/gapminder_wide.csv")
gapminder <- read_csv("data/gapminder-FiveYearData.csv")
gapminder #give me a shortview of the file

# plot things
# '+' means that we continue the cmd
# Generate aesthetic mappings that describe 
# how variables in the data are mapped to visual 
# Does people leaving in richer country leave longer?
ggplot(data=gapminder)+ 
  geom_point(mapping=aes(x=gdpPercap,y=lifeExp))

# How life expectance changed over the years?
ggplot(data=gapminder)+ 
  geom_jitter(mapping=aes(x=year,y=lifeExp))
# replace geom_point with geom_jitter so that we se better the points
# it spreads the points on the X-axis

# life exp per continent?
ggplot(data=gapminder)+ 
  geom_jitter(mapping=aes(x=continent,y=lifeExp))

# change aspect
# type of legend: one color per continent
ggplot(data=gapminder)+ 
  geom_jitter(mapping=aes(x=year,y=lifeExp, color=continent))


ggplot(data=gapminder)+ 
  geom_jitter(mapping=aes(x=continent,y=lifeExp, color=year))
# the type of legend changes, because the years are contiuous
# get a colorbar with continuous color
# same for X axis:
# when continent, categories
# when years: axis continuous

# plot in lin/log and with colors, 
# changing also the size of the points in function of population
# changing the color with the years
# shape= continent
ggplot(data=gapminder)+ 
  geom_jitter(mapping=aes(x=log(gdpPercap),y=lifeExp, 
                          color=year, size=pop, shape=continent))

# if we want a particular color, size of point for all the data
# we put attributes out of the aes function
# instead of using geom_jitter
# using geop_point by plotting semi-transparent points so we see all of them
ggplot(data=gapminder)+ 
  geom_point(mapping=aes(x=log(gdpPercap),y=lifeExp), 
                          color="blue", size=2, alpha=0.2, shape=5, stroke=0.5)

# another funtion
# geom_line: try to connect points
ggplot(data=gapminder)+ 
  geom_line(mapping=aes(x=year,y=lifeExp, group=country, color=continent))

# expectancy by continent
# boite à moustache boxplot
# stat distribution
# combine jitter and boxplot to see the data back
# the order of the layers changes with the order of the ccommands
ggplot(data=gapminder)+ 
  geom_boxplot(mapping=aes(x=continent,y=lifeExp))+
  geom_jitter(mapping=aes(x=continent,y=lifeExp, color=continent), alpha=0.2)


# if you want the same attributes for 2 functions:
ggplot(data=gapminder,
  mapping=aes(x=continent,y=lifeExp, color=continent))+
    geom_jitter()+
   geom_boxplot()
  

# applying transparency to the geom point layer only
ggplot(data=gapminder,
       mapping=aes(x=log(gdpPercap),y=lifeExp, color=continent))+
  geom_point(alpha=0.5)+
  geom_smooth(method="lm") #add a 3rd layer, linear regression fitted by continent

# applying transparency to the geom point layer only
ggplot(data=gapminder,
       mapping=aes(x=log(gdpPercap),y=lifeExp, color=continent))+
  geom_point(alpha=0.5)+
  geom_smooth(method="lm") #add a 3rd layer, linear regression fitted by continent

# applying transparency to the geom point layer only
ggplot(data=gapminder,
       mapping=aes(x=log(gdpPercap),y=lifeExp, color=continent))+
  geom_point(alpha=0.5)+
  geom_smooth(method="lm",color="blue") #

ggplot(data=gapminder,
       mapping=aes(x=log(gdpPercap),y=lifeExp))+
  geom_point(mapping=aes(color=continent), alpha=0.5)+
  geom_smooth(method="lm") 
#add a 3rd layer, linear regression fitted by continent


ggplot(data=gapminder,
       mapping=aes(x=gdpPercap,y=lifeExp,color=continent))+
  geom_point(alpha=0.5)+
  geom_smooth()+
  scale_x_log10()


# challenge
ggplot(data=gapminder,
       mapping=aes(x=year,y=lifeExp, color=continent))+
  geom_boxplot()

ggplot(data=gapminder,
       mapping=aes(x=year,y=gdpPercap, group=year))+
  geom_boxplot()+ # group all the continent per year
  # if group=year is not there, it just group all the data and produces a big box
scale_y_log10()
# scale is transformed but not the scale of the box, therefore it looks 
# symetric - remove scale_y_log10 to see what I mean

ggplot(data=gapminder,
       mapping=aes(x=gdpPercap,y=lifeExp))+
  geom_point()+
  geom_smooth(method="lm")+
  scale_x_log10()+
  #facet_wrap(~ continent) # chopping the data by continent
  facet_wrap(~ year) # chopping the data by year
# mapping subplot per continent/year

ggplot(gapminder)+# skip data def
  geom_bar(aes(x=continent))# skip mapping def bec we know it is there
# create a new variable, count the number of data per continent


#
ggplot(filter(gapminder,year==2007))+# only data of 2007
  geom_bar(aes(x=continent))
# count nb of obs per continent in 2007

#  we want 1 bar per coutry
ggplot(filter(gapminder,year==2007, continent=="Americas"))+# only data of 2007
 # geom_bar(aes(x=country, y=pop))
# does not work, because geom_bar by default produces the variable count
  geom_bar(aes(x=country, y=pop), stat="identity")+
  coord_flip()# to put the countries on the vertical axis (becaus not enough place horizontally)
# keep the y data as identical instead of defining the variable count

p <- ggplot(data=gapminder)+ 
  geom_jitter(mapping=aes(x=(gdpPercap/10^3),y=lifeExp, 
                          color=continent, size=pop/10^6))+ #both notations 10^6 or 1e6 OK
  facet_wrap(~ year)+ # chopping the data by year
  scale_x_log10()+
  labs(title="Life exp vs GDP per capita over time",
subtitle="life expectancy improved during the last 50 years",
caption="Great graph",
x="GDP per capita, '000 USD", # change the data so that the legend is right
color="Continent",
size="Population in millions")


# save figure:
# either use the export button on the figure
# or more elegant:
ggsave("myplot.png", plot=p, width=10, height=9)#, width=40,height=20)



ggplot(data=gapminder, mapping=aes(x=gdpPercap, y=lifeExp))+
  geom_point()+
  geom_smooth()+
  scale_x_log10()+
  facet_wrap(~continent)

ggplot(data=gapminder, mapping=aes(x=gdpPercap, y=lifeExp))+
  geom_point()+
  geom_smooth(method='lm')+
  scale_x_log10()+
  facet_wrap(~continent)

ggplot(data=filter(gapminder, year==2007))+
  geom_bar(mapping=aes(x=continent))
# by default, R put the count on y axis, even if we did not specify it

# Here we get exactely the same plot, but we explicit the count
ggplot(data=filter(gapminder, year==2007))+
  geom_bar(mapping=aes(x=continent), stat="count")

#filter even more:
filter(gapminder, year==2007, continent=="Oceania")

# We don't want to count anything, we just want to plot the population vs country
# No transformation: identity, R should not do anything else than what I want
# Don't use count if you specify y=
# in geom_bar, count is the function by default. 
# It dependts on the functions, check the help
ggplot(data=filter(gapminder, year==2007, continent=="Oceania"))+
  geom_bar(mapping=aes(x=country, y=pop), stat="identity")

# use another function: geom_col
ggplot(data=filter(gapminder, year==2007, continent=="Asia"))+
  geom_col(mapping=aes(x=country, y=pop))
# can't read anything => flip things
ggplot(data=filter(gapminder, year==2007, continent=="Asia"))+
  geom_col(mapping=aes(x=country, y=pop))+
  coord_flip()
# with color, facetting
ggplot(data=gapminder, mapping=aes(x=gdpPercap, y=lifeExp, 
                                   color=continent, size=pop/10^6))+
         geom_point()+
         scale_x_log10()+
         facet_wrap(~year)+
  labs(title="Life expectancy vs GDP per capita over time", 
       subtitle="life expectany improved in most countries!",
       caption="Source: Gapminder fundation, htpp//blablabla",
       x="GDP per capita, in 000 USD",
       y="Life expectancy, year",
       color="Continent",
  size="Population, in millions")

#face_wrap
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  geom_smooth() +
  scale_x_log10() + 
  facet_wrap( ~ continent)


ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  geom_smooth() +
  scale_x_log10()  
# search for help:
# type ? keyword
# ? search in the package that you have uploaded
# when  packages are uploaded, helpfile is also uploaded
# ?? search deeper, also in the package that are not uploaded

as.factor





