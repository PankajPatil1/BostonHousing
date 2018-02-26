# A regression model approach to predict the Boston Housing prices 
An analytical approach to predict the prices of Housing in Boston

The data set has information about 14 variables including the median prices of housing in Boston area. The variables include criminal activity, industrial area, taxes etc.
These variables are analysed and a regression model is developed to predict the prices of housing in Boston

The details of model fitted are as below:

```lm(formula = log(medv) ~ chas + rm + ptratio + b^2 + lstat, data = train2)

Residuals:

     Min       1Q   Median       3Q      Max 
-0.56057 -0.07315  0.00219  0.08679  0.49540 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)  2.5952972  0.1682498  15.425  < 2e-16 
chas         0.1324514  0.0395760   3.347 0.000912 
rm           0.1918338  0.0168279  11.400  < 2e-16 
ptratio     -0.0362855  0.0041362  -8.773  < 2e-16 
b            0.0006359  0.0001048   6.069 3.53e-09 
lstat       -0.0260568  0.0017686 -14.733  < 2e-16 
---

Residual standard error: 0.1519 on 329 degrees of freedom
Multiple R-squared:  0.8413,	Adjusted R-squared:  0.8389 
F-statistic: 348.7 on 5 and 329 DF,  p-value: < 2.2e-16
```

**The accuracy of this model has been verified to be around 95%**         
