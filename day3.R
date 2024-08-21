data<- read.csv("C:/Users/risha/Downloads/Scooby-Doo Completed.csv")

head(data)

colnames(data)

# avg runtime 
mean(data$run.time)

mean(data$imdb) #before getting the mean type cast it into numeric.

tail(data$imdb)  # this has null values.

#by myself
install.packages("dplyr")
library(dplyr)
data <- data %>%
mutate(imdb = as.numeric(imdb))

tail(imdb)


data$imdb<-as.numeric(data)   # to type cast in numeric.
mean(data$imdb)

?mean
mean(data$imdb, na.rm = TRUE)   #To get the mean.


# subsetting and retain only the needed columns.
df<-select(data, 2:10)
View(df)


# with pipe operator.
df2<- data %>%
  select(data, 2:10)
View(df)




#how many distinct values of network exist.

unique(data$network)

# visualization imdb rating over time.
library(ggplot2)
ggplot(data, aes(x = date.aired, y = imdb, color = format)) +
    geom_point()

table(data$format)


#how did the trends in channels broadcastingSD, change over time?

ggplot(df, aes(x=date.aired ,y=imdb , color=network)) +
      geom_point()

df$date.aired<-as.Date(df$date.aired)
ggplot(df, aes(x=date.aired , y=imdb , color=network )) +
  geom_point() + scale_x_date(date_breaks = "10 year" ,date_labels = "%d %m %Y") +
  theme(axis.text.x = element_text(angle = 10 , hjust =1 ))
#OR
df$date.aired <- as.Date(df$date.aired)

ggplot(df, aes(x = date.aired, y = imdb, color = network)) +
  geom_point() +
  scale_x_date(
    breaks = seq(as.Date("1969-09-13"), as.Date("2021-02-05"), by = "10 years"),
    date_labels = "%d %m %Y"
  ) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1))


# only formats that records TV series.

segmented_epi<-df %>% 
  filter(format=="TV Series (segmented)")
segmented_epi %>% 
  group_by(date.aired) %>% 
  summarise(imdb=mean(imdb),
            network=unique(network),
            series.name=unique(series.name),
            total_runtime_per_epi = sum(run.time)
            )
View(segmented_epi)
table(segmented_epi$format)


scooby_tv_series<-df %>% 
  filter(format=="TV Series ") #374

scooby_tv_series_2<-scooby_tv_series %>% 
  select(date.aired,
         imdb,
         network
         ,series.name,
         total_runtime_per_epi=run.time)

scooby_cleaned<- rbind(scooby_tv_series_2 , segmented_epi)  
