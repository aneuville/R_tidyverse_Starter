# lif exp average per continent
gapminder_plus %>%
  group_by(continent) %>% 
  summarize(mean_le=mean(lifeExp),
            min_le=min(lifeExp),
            max_le=max(lifeExp))
# for loop running in the background

gapminder_plus %>%
  ggplot()+
  geom_line(mapping=aes(x=year, y=lifeExp, color=continent))
# 1 line per country...should group

gapminder_plus %>%
  ggplot()+
  geom_line(mapping=aes(x=year, y=lifeExp, color=continent, group=country))
# 1 line per country...should group
# life expen per year per country

# add fit
gapminder_plus %>%
  ggplot()+
  geom_line(mapping=aes(x=year, y=lifeExp, color=continent, group=country))+
  geom_smooth(mapping=aes(x=year, y=lifeExp), color="black", method='lm')+
  facet_wrap(~continent)


by_country <- gapminder_plus %>%
  group_by(continent, country)%>%
  nest() # put variables in a list except thos specified in group_by

by_country$data[[1]] # take data for the 2nd continent
by_country$data[[2]] # take data for the 2nd continent

library(purrr) # conflict with the other package map
# need to call purrr:map instead of just map

purrr::map(1:3, sqrt)

by_country %>%
  mutate(model=purrr::map(data,~lm(lifeExp~year,data=.x))) %>% #map operate on a list using a function
  mutate(sumr=purrr::map(model, broom::glance)) %>%
  unnest(sumr) %>% arrange(r.squared) %>%
  ggplot()+
  geom_jitter(mapping=aes(x=continent, y=r.squared))

# explore the outliers = <0.5
by_country %>%
  mutate(model=purrr::map(data,~lm(lifeExp~year,data=.x))) %>% 
  #map operate on a list using a function
  # mutate: iterates
  mutate(sumr=purrr::map(model, broom::glance)) %>%
  # gance: extractes more info about the fit as a table
  unnest(sumr) %>% 
  arrange(r.squared) %>%
  # unpackage and brings back the initial vectors
  # arrange was just for vizualization purpose, not necessary
  filter(r.squared<0.3)%>% 
  # vizualize countries which has large error on the fit
  select(country) %>%
  left_join(gapminder_plus) %>%
  ggplot()+
  geom_line(mapping=aes(x=year, y=lifeExp, color=country, group=country))
# rwanda: civil war
# Other with low life Exp: SIDA

geom_jitter(mapping=aes(x=continent, y=r.squared))

# arrange: sort per column
model_by_country

# life exp vs gdpPercap
# does hiegher gdpPercap means higher lifeExp
# can we buy our life?

gapminder_plus %>%
  ggplot()+
  geom_point(mapping = aes(x=log(gdpPercap), y=lifeExp))

gapminder_plus %>%
  ggplot()+
  geom_line(mapping = aes(x=log(gdpPercap), y=lifeExp, color=continent, group=country))

by_country %>%
  mutate(model=purrr::map(data,~lm(lifeExp~log(gdpPercap), data=.x))) %>% #map operate on a list using a function
  mutate(sumr=purrr::map(model, broom::glance)) %>%
  unnest(sumr) %>%
  arrange(r.squared) %>%
  filter(r.squared<0.1)%>%
  select(country) %>%
  left_join(gapminder_plus)%>%
  ggplot()+
  geom_jitter(mapping=aes(x=log(gdpPercap), y=lifeExp, color=country))

# save
saveRDS(by_country,"by_country_tibble.rds")

# Loas RDS
my_fresh_data<-readRDS("by_country_tibble.rds")
# rds: only readable in R
write_csv(gapminder_plus,"gapminder_plus_for_other.csv")