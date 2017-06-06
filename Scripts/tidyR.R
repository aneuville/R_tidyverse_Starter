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

# we want git to be aware of our chabges
# we want the updated version of today available on the repository online
# Git dans la fenetre à droite dans Rstudio
# select the file you want to commit
# configure your account if not already done:
# git config --global user.email amelie@fys.uio.no
# amelie@melis:~ $  git config --global user.name aneuville
# click on commit

  