data()
?mtcars

?mean

#to view the entire data frame we use--
View(mtcars)
#filter
install.packages("dplyr")
library(dplyr)

glimpse(mtcars)   # it's like df.info

 #if we are not sure what the func does we use--
?filter
#to filter out the specific rows we can use methods like"
#to find the cars which have the mileage above 25:
mpg_efficient <- filter(mtcars, mpg > 25)
dim(mpg_efficient)

#to add new column or modify--
?mutate  # to convert miles per kalen into km
mpg_metric<-mutate(mtcars,kmpl=mpg *0.42)
dim(mpg_metric)
View(mtcars)  # to view tht the values has changed in km.
# ctr+shift+c for multi line comments


# perform the same task using the 'pipe' operator.
#%>% :ctrl+shift+m

mtcars2<-mtcars%>%  # "%>%"  it passes the output of one function  in other.
            mutate(kmpl=mpg *0.42)
# to rename the column
            rename(metric_mileage = kmpl)  
              # Rename the column 'kmpl' to 'metric_mileage'
            print(mtcars2)
#3) for each value of transmission
# to find the average weight of the car:
names(mtcars)
mtcars %>% 
  group_by('am') %>% 
  summarise(mean(wt))   #to get the mean

#4) Data visualization:
library(ggplot2)
ggplot(mtcars,aes(x=hp))+ geom_histogram()
# so there are gaps so we geom_point()# so there are gaps so we can control the bins by using
ggplot(mtcars,aes(x=hp))+ geom_histogram(bins =10 )+ labs(x="Horsepower")   

#display the data for only 'mercedes' related cars
#df[df['carnames]].str.startswith('Merc') this is in python


#Assume that a column called car name exists:
# Assume that all the meercedes -related rows has the carbrand'Mercedes':
#df[df['carbrand'']=='Mercedes']  This is in python

mtcars %>%   #with pipe operator
  filter()  

attributes(mtcars)

mtcars3<-mtcars
mtcars3$carname=rownames(mtcars)

# s_id,s_name, s_phone
mtcars3 %>% 
  filter()
#mtcars display the data for only mercedes

