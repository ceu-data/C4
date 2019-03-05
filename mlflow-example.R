install.packages("mlflow")

student_id = "<<YOUR STUDENT ID>>"
library(mlflow)

scatter.smooth(x=cars$speed, y=cars$dist, main="Dist ~ Speed")  # scatterplot
mlflow_set_tracking_uri("http://mlflow.datapao.com:5000")
mlflow_end_run() # Just to be sure
mlflow_start_run(source_name = paste(paste("lm_traintest_08-",student_id,sep="0"))) # Don't use spaces here

seed = 273
mlflow_log_param("seed", seed)
mlflow_log_param("method", "lm")

trainTestRatio = 0.8
mlflow_log_param("trainTestRatio", trainTestRatio)
trainingRowIndex <- sample(1:nrow(cars), trainTestRatio*nrow(cars))  # row indices for training data
training <- cars[trainingRowIndex, ]  # model training data
test  <- cars[-trainingRowIndex, ]   # test data

set.seed(seed)
lmMod <- lm(dist ~ speed, data=trainingData) # train model
summary(lmMod)

pred <- predict(lmMod, testData)  # predict distance
rmse <- function(m, o) sqrt(mean((m - o)^2))
testRMSE = rmse(pred, test)
testRMSE
mlflow_log_metric("rmse", testRMSE)

rsq <- function (x, y) cor(x, y) ^ 2
testRSQ = rsq(pred, test)
testRSQ[2]
mlflow_log_metric("rsq", testRSQ[2])

mlflow_end_run("FINISHED")

# =================================

ratio = 0.6
mlflow_end_run()
mlflow_start_run(source_name = paste("lm_traintest_",ratio,"_",student_id, sep="")) # Don't use spaces here

seed = 273
mlflow_log_param("seed", seed)
mlflow_log_param("method", "lm")

trainTestRatio = ratio
mlflow_log_param("trainTestRatio", trainTestRatio)
trainingRowIndex <- sample(1:nrow(cars), trainTestRatio*nrow(cars))  # row indices for training data
training <- cars[trainingRowIndex, ]  # model training data
test  <- cars[-trainingRowIndex, ]   # test data

set.seed(seed)
lmMod <- lm(dist ~ speed, data=trainingData) # train model
summary(lmMod)

pred <- predict(lmMod, testData)  # predict distance
rmse <- function(m, o) sqrt(mean((m - o)^2))
testRMSE = rmse(pred, test)
testRMSE
mlflow_log_metric("rmse", testRMSE)

rsq <- function (x, y) cor(x, y) ^ 2
testRSQ = rsq(pred, test)
testRSQ[2]
mlflow_log_metric("rsq", testRSQ[2])

mlflow_end_run("FINISHED")


