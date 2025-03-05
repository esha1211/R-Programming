# R-Programming

## Overview
This project builds predictive models to determine the likelihood of a credit card application being approved based on financial and demographic factors. The models leverage **Linear Regression** and **Multivariate Adaptive Regression Splines (MARS)** to analyze key applicant features.

## Project Files
### `Model_Training.r`
- Loads and processes the dataset.
- Trains multiple **predictive models** (Linear Regression & MARS).
- Performs **cross-validation** for accuracy evaluation.
- Saves the best-performing models to `MyModels.RData`.

### `credit_card_data.csv`
- The dataset contains anonymized applicant details, including:  
  - **Financial Factors**: Income, credit history, expenditures.  
  - **Demographics**: Age, homeownership, employment status.  
  - **Target Variable**: `card` (1 = Approved, 0 = Rejected).  

## How to Run the Model
### Install the required package (if not installed yet):
```r
install.packages("earth")
