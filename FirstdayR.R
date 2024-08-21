data() # shows the avbl, built in datasts.

  # to show the dimensions # keyboard shortcut for running the cells (ctrl+enter)
dim(iris)
names(iris) # to show the column names
str(iris)  # df.info
head(iris,2)  # to show the first 6 rows
tail(iris,3)  # for last 6 rows
iris[1:3,]  # (,) is used otherwise it will show all values.

attributes(iris)  # display both set of labels
# missing values per column
colSums(is.na(iris))


iris$Sepal.Length 
iris$Sepal.Length[1:10]   # to show the length of specific rows.
summary(iris)   # statistical summary

install.packages("Hmisc" ,dependencies = TRUE)
library(Hmisc)
describe(iris)
describe(iris),c[1,3])
fruits<-c("apple","banana","mango")
fruits<-c("apple","banana","mango",0)


range(iris$Sepal.Length)
quantile(iris$Sepal.Length)
quantile(iris$Sepal.Length,c(0.1,0.2,0.3))

         
#visualization 
#histograms
hist(iris$Sepal.Length)
var(iris$Sepal.Length) # variance

#To show in tabular form
table(iris$Species)  # in form of tables
pie(table(iris$Species))
barplot(table(iris$Species))

boxplot(iris$Sepal.Length)
boxplot(iris$Sepal.Length, ylim = c(4,8))
boxplot(iris$Petal.Length)

plot(iris$Sepal.Length,iris$Petal.Length)


#Bivariate analysis
plot(iris$Sepal.Length,iris$Petal.Length , col=iris$Species)
#OR  both will show the same output
with(iris,
     plot(Sepal.Length,Petal.Length ,col=Species,pch=as.integer(Species))
  
)
library(ggplot2)
ggplot(iris,
       aes(Sepal.Length,Petal.Length , color= Species)
        )+ geom_point()

#Pairplots
pairs(iris)



