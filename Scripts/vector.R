# vectors
x<-5*6
x

is.vector(x)
length(x)
x[2]<-31
x[5]<-44 # NaN in between position 2 ad 5
x[11] # not defined => NaN
x[0] # R starts at position 1, numeric(0), non existent index
x<-1:4 # sequence 1 to 4
y<-x^2
# if no vectorization:
z<-vector(mode=mode(x), length=length(x))
for(i in seq_along(x)){
  z[i]<-x[i]^2
}


x<-1:5
x
y<-3:7
y
x+y

z<--y[-2] # remove the second
z
y
y+z # recycling, repeat the vector if it is not the right length dangerous behavior
# but! be careful recycling can be silencious...
# when the length are multiple

z<-1:10

z+x # recycling silenciously!

# but recycling make it possile to rise to the power something

z^x

x
y=-x[-4]
y[3]=NA
y

x+y
# missing values propagates

c("Hello", "workshop", "participants!")

str(c("Hello", "workshop", "participants!"))
str(c(9:11,200,x)) # str tell me the type
# here: same type

c("something", pi, 2:4, pi>3)
# mixed type, will consider all as characters

c(pi, 2:4, pi>3)
# logical value is then considered as numeric
# take the smallest unit, here does not need to go to character, numeric is enoug
# R very loose on the type!!

c(2L:4L, pi<3) # L???

w<-rnorm(10)
w
seq_along(w)
which(w<0)

w[which(w<0)] # numerical susstituting
w[w<0] # logical substituting

w[-c(2,5)] 
# - drop element
# combine position 2 and 5
# => loose elements 2 and 5

# vector can contain only one type of data
# list keeps the types
str(list("something", pi,9:12, pi>3))
# str gives the type + index

x<-list(vegetable="chou",
     number=pi,
     series=2:4,
     telling=pi>3)
str(x)

x$vegetable # get the vegetable: not a "dot" but a "$"!!
x[1]
str(x[1])
str(x$vegetable)
# $ ; return the type
# x[1] 

str(x[[3]]) #return it as a list
str(x[3])


x<-list(vegetable=list("chou, carottes"),
        number=list(c(pi,0,NA)),
        series=list(list(2:4,3:6)),
        telling=pi>3)
str(x)
x[1]
x$vegetable # is a list

str(x$vegetable)
mod<- lm(lifeExp~gdpPercap, data=gapminder_plus) #linear model
# got a complex list as result...
# do we manage to get df.residual?

mod[8] # get a list
mod[[8]] # get unpakkaging it out of the list
# or:
mod$df.residual
# or
mod[["df.residual"]]

el<-mod$qr
str(el)

elb=el$qr
elb %>% View
elb[1]
# or directly:
mod$qr$qr[1]
# or
mod$qr$qr[1,1]
#


