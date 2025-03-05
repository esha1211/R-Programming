
install.packages('earth')
library('earth')

setwd('/Users/esha/Desktop/untitled folder') 


bankData = read.csv('credit_card_data.csv') 



getBankDataKFoldRMSE = function(testFit){
  set.seed(354987)
  totalFold = 5
  
  #Get the fold number for each row 
  foldNum = floor(runif(nrow(bankData))*totalFold)+1
  
  #Make a place to store the errors for each fold 
  thisModelRMSE = rep(NA,totalFold)
  
  for(thisFold in 1:totalFold){
	#Training Data is everything not in the fold 
    trainingData = subset(bankData,foldNum!=thisFold)
	
	#Validation data is everything in the fold 
    validationData = subset(bankData,foldNum==thisFold)
	
	#Update model fit based on training data 
    thisModel = update(testFit,data=trainingData)
	
	#Get error in validation data 
    thisFit = mean((predict(thisModel,validationData) - validationData$card)^2)^.5
	
	#Store the RMSE 
    thisModelRMSE[thisFold] = thisFit
  }
  
  #Return the error rate 
  return(mean(thisModelRMSE))
}


###################################################
#Train the model 
formulas_no_expenditure <- list(
  card ~ reports + age + income,
  card ~ reports + age + income + owner,
  card ~ reports + age + income + selfemp,
  card ~ reports + income + share,
  card ~ reports + income + dependents,
  card ~ reports + income + months,
  card ~ age + income + owner,
  card ~ age + income + selfemp,
  card ~ age + income + majorcards,
  card ~ income + share + owner,
  card ~ income + share + selfemp,
  card ~ income + share + active,
  card ~ reports + income * owner,
  card ~ reports + income * selfemp,
  card ~ age + income * owner,
  card ~ age + income * selfemp,
  card ~ age + owner * selfemp,
  card ~ age + dependents + active,
  card ~ income + majorcards + active,
  card ~ income + months + active,
  card ~ reports + majorcards + dependents,
  card ~ reports + age + active,
  card ~ income + owner + dependents,
  card ~ income + owner + majorcards,
  card ~ income + active + dependents,
  card ~ reports + active + months,
  card ~ reports + age + months + active,
  card ~ age + income + majorcards + active,
  card ~ reports + age + income + active,
  card ~ reports + income * majorcards,
  card ~ income * majorcards * owner,
  card ~ income * owner * selfemp,
  card ~ reports + income + age * owner,
  card ~ reports + age + income * active
)





#Store your final model 
formulas_with_expenditure <- list(
  card ~ reports + age + income + expenditure,
  card ~ reports + age + income + expenditure + owner,
  card ~ reports + age + income + expenditure + selfemp,
  card ~ reports + income + expenditure + share,
  card ~ reports + income + expenditure + dependents,
  card ~ reports + income + expenditure + months,
  card ~ age + income + expenditure + owner,
  card ~ age + income + expenditure + selfemp,
  card ~ age + income + expenditure + majorcards,
  card ~ income + share + expenditure + owner,
  card ~ income + share + expenditure + selfemp,
  card ~ income + share + expenditure + active,
  card ~ reports + expenditure + income * owner,
  card ~ reports + expenditure + income * selfemp,
  card ~ age + expenditure + income * owner,
  card ~ age + expenditure + income * selfemp,
  card ~ age + expenditure + owner * selfemp,
  card ~ age + expenditure + dependents + active,
  card ~ income + expenditure + majorcards + active,
  card ~ income + expenditure + months + active,
  card ~ reports + expenditure + majorcards + dependents,
  card ~ reports + expenditure + age + active,
  card ~ income + expenditure + owner + dependents,
  card ~ income + expenditure + owner + majorcards,
  card ~ income + expenditure + active + dependents,
  card ~ reports + expenditure + active + months,
  card ~ reports + expenditure + age + months + active,
  card ~ age + expenditure + income + majorcards + active,
  card ~ reports + expenditure + age + income + active,
  card ~ reports + expenditure + income * majorcards,
  card ~ expenditure + income * majorcards * owner,
  card ~ expenditure + income * owner * selfemp,
  card ~ reports + expenditure + income + age * owner,
  card ~ reports + expenditure + age + income * active
)

# Threshold values for MARS tuning
thresholds <- c(0.01, 0.02, 0.03)

# Train for model1A
for (i in seq_along(formulas_no_expenditure)) {
  spec <- formulas_no_expenditure[[i]]
  
  # Linear Model
  linear_model <- lm(spec, data = bankData)
  linear_rmse <- getBankDataKFoldRMSE(linear_model)
  linear_results[[paste0("lm_model1A_", i)]] <- list(model = linear_model, rmse = linear_rmse)
  
  # MARS Models with tuning
  for (thresh in thresholds) {
    mars_model <- earth(spec, data = bankData, thresh = thresh)
    mars_rmse <- getBankDataKFoldRMSE(mars_model)
    mars_results[[paste0("mars_model1A_", i, "thresh", thresh)]] <- list(model = mars_model, rmse = mars_rmse)
  }
}

# Train for model1B
for (i in seq_along(formulas_with_expenditure)) {
  spec <- formulas_with_expenditure[[i]]
  
  # Linear Model
  linear_model <- lm(spec, data = bankData)
  linear_rmse <- getBankDataKFoldRMSE(linear_model)
  linear_results[[paste0("lm_model1B_", i)]] <- list(model = linear_model, rmse = linear_rmse)
  
  # MARS Models with tuning
  for (thresh in thresholds) {
    mars_model <- earth(spec, data = bankData, thresh = thresh)
    mars_rmse <- getBankDataKFoldRMSE(mars_model)
    mars_results[[paste0("mars_model1B_", i, "thresh", thresh)]] <- list(model = mars_model, rmse = mars_rmse)
  }
}

###################################################
# Find the best models
# Combine all model results for model1A
model1A_results <- c(
  linear_results[grep("lm_model1A_", names(linear_results))],
  mars_results[grep("mars_model1A_", names(mars_results))]
)
best_model1A_name <- names(model1A_results)[which.min(sapply(model1A_results, function(x) x$rmse))]
model1A <- model1A_results[[best_model1A_name]]$model

# Combine all model results for model1B
model1B_results <- c(
  linear_results[grep("lm_model1B_", names(linear_results))],
  mars_results[grep("mars_model1B_", names(mars_results))]
)
best_model1B_name <- names(model1B_results)[which.min(sapply(model1B_results, function(x) x$rmse))]
model1B <- model1B_results[[best_model1B_name]]$model




################################################################## 
##################################################################

model1A$cv.list = NULL
model1A$cv.oof.fit.tab = NULL
model1A$varmod = NULL

model1B$cv.list = NULL
model1B$cv.oof.fit.tab = NULL
model1B$varmod = NULL

isError = FALSE

if(!(class(model1A)=='earth'|class(model1A)=='lm')){
	print('model1A is not an earth or lm model.  Be sure to submit a statistical model here.')
  isError = TRUE}
	
if(!(class(model1B)=='earth'|class(model1B)=='lm')){
	print('model1B is not an earth or lm model.  Be sure to submit a statistical model here.')
  isError = TRUE}


if(class(model1A)=='earth'){
	noExpenditure = !(grepl('expenditure',paste(rownames(model1A$coefficients),collapse=' ')))
}  else {
	noExpenditure = !(grepl('expenditure',paste(names(model1A$coefficients),collapse=' ')))
}

if(!noExpenditure){
	print('Make sure you do not use the expenditure variable in model1A')
  isError = TRUE
}

if(!isError){
  save(model1A, model1B, file = 'MyModels.Rdata')
  print('MyModels.Rdata generated!.')
} else {
  print('Your code does not produce the right output.')
}

ls()
