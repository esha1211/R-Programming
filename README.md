# R-Programming

## Credit Card Approval Prediction

## Overview  
This project builds and evaluates predictive models to determine credit card approval likelihood based on applicant features. The dataset (`credit_card_data.csv`) includes various demographic and financial attributes.

## Files  
- **`credit_card_data.csv`** - Contains the dataset used for training and evaluation.  
- **`Model_Training.r`** - R script that:
  - Loads and preprocesses the dataset.
  - Implements K-Fold cross-validation.
  - Trains multiple models using linear regression and MARS (Multivariate Adaptive Regression Splines).
  - Selects the best-performing models based on RMSE (Root Mean Squared Error).

## Model Details  

- **Model 1A**: Trained without the `expenditure` variable.  
- **Model 1B**: Trained with the `expenditure` variable.  
- Both models use different feature combinations and tuning thresholds for optimization.

## Output  

- The script performs **cross-validation** and selects the **best models** based on RMSE.  
- If errors occur (e.g., incorrect model submission), the script provides warnings.  
- A successful run generates `MyModels.Rdata`, which contains the trained models.

## Dependencies  

Ensure you have the following R package installed before running the script:  

```r
install.packages('earth')
