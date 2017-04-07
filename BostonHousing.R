require(ggplot2)
require(mlbench)
require(reshape2)
require(e1071)
data(BostonHousing)
dim(BostonHousing)
View(BostonHousing)

#Missing Value checks
comp <- complete.cases(BostonHousing)
summary(BostonHousing) #Hint of outliers in crim and zn variables
str(BostonHousing)
BostonHousing$chas <- as.numeric(BostonHousing$chas) - 1
cor(BostonHousing) #features are not highly correlated

#Check Q-Q Plot
qqnorm(BostonHousing$medv)
qqline(BostonHousing$medv)
#Split the data into train and test
#70:30 Ratio for splitting
trainIndex <- sample(1:506,size = 0.7*506)
train <- BostonHousing[trainIndex,]
test <- BostonHousing[-trainIndex,]

bh <- BostonHousing #Ease for typing :p

mbh <- melt(bh)
ggplot(mbh,aes(x=value)) + stat_density() + facet_wrap(~variable,scales="free")
ggplot(data=mbh,aes(x=value)) + stat_density() + facet_wrap(~variable,scales="free")

#The variables crim,zn,chas,dis,b are highly skewed
#Let us calculate the skewness
skew <- sapply(bh,skewness)
print(skew)

#Generally speaking skew > 1 needs to be transformed
#crim,zn,chas,dis,b,medv need to be transformed but since chas is binary, we will not apply any transformation to it
#Let us apply simple transformations of log for right skew and squaring for left skew
model <- lm(log(medv)~log(crim)+(zn)+indus+chas+(nox)+rm+age+log(dis)+(rad)+(tax)+ptratio+b^2+(lstat),data=train)
summary(model)

# We find that log(crim),zn,indus,chas,age are not significant
# So we recreate the model without using these variables
model2 <- lm(log(medv)~chas+nox+rm+log(dis)+tax+ptratio+b^2+lstat,data=train)
summary(model2)
confint(model2,level = 0.95)

#R squared value is 0.7593. Which means that almost75% of variance in data is explained by regression
anova(model2)

#This tells us that log(dis) is insignificant jointly, so we drop that variable too
model3 <- lm(log(medv)~chas+nox+rm+tax+ptratio+b^2+lstat,data=train)
summary(model3)

#We find that nox and tax are insignifacnt
model4 <- lm(log(medv)~chas+rm+ptratio+b^2+lstat,data=train)
summary(model4)

#Let us look for any outliers that might be affecting the regression
#We shall use cooks distance for this
cooksd <- cooks.distance(model4)
cooksd.dataframe <- data.frame(names(cooksd),cooksd)
ggplot(cooksd.dataframe,aes(x=names.cooksd.,y=cooksd)) + geom_point() + geom_hline(yintercept=4*mean(cooksd),col="red") + geom_text(aes(label=ifelse(cooksd>4*mean(cooksd),names.cooksd.,"")),col="red")

#Those parameters having cooksd greater than 4*mean(cooksd) are outliers and need to be removed
influential <- cooksd>4*mean(cooksd)
train2 <- train[!influential,]

#Let us re-train the model using train2 as the training dataset
model4 <- lm(log(medv)~chas+rm+ptratio+b^2+lstat,data=train2)
summary(model4)

#The R squared values have increased to 0.84 . That means almost 84% of variance is explained by the regression model
future <- predict.lm(model4,newdata=test)
comparison <- data.frame(future,log(test$medv))
comparison$Error <- (abs(comparison[,2] - comparison[,1])/comparison[,2])*100
MAPE <- (mean(comparison$Error))
MAPE
View(comparison)
#Check residuals
model.dataframe <- fortify(model4)
ggplot(model.dataframe,aes(x=.resid)) + geom_histogram()
summary(model.dataframe$.resid)
ggplot(model.dataframe,aes(x=.resid)) + stat_density() + geom_vline(aes(xintercept = mean(.resid)),col="red")
ggplot(model.dataframe,aes(x=.resid,y=.fitted)) + geom_point() + stat_smooth(se=FALSE,method="lm")

#The residuals are normally distributed

#Inaccuracy varies around 5%


