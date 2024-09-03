# abalone_analysis.R

# Step 1: Load required libraries
library(readxl)       # For reading Excel files
library(dplyr)        # For data manipulation
library(ggplot2)      # For data visualization
library(caret)        # For data splitting and model training
library(e1071)        # For regression model
library(corrplot)     # For correlation plots

# Step 2: Load the data
load_data <- function(file_path) {
  df <- read_excel(file_path, sheet = "Original Data")
  colnames(df) <- df[2, ]  # Use the second row as column names
  df <- df[-c(1, 2), ]     # Remove the first two rows
  df <- df %>% as.data.frame()
  return(df)
}

# Step 3: Preprocess the data
preprocess_data <- function(df) {
  # Convert numeric columns to appropriate types
  df$Length <- as.numeric(df$Length)
  df$Diameter <- as.numeric(df$Diameter)
  df$Height <- as.numeric(df$Height)
  df$Whole_weight <- as.numeric(df$Whole_weight)
  df$Shucked_weight <- as.numeric(df$Shucked_weight)
  df$Viscera_weight <- as.numeric(df$Viscera_weight)
  df$Shell_weight <- as.numeric(df$Shell_weight)
  df$Rings <- as.integer(df$Rings)
  
  # Encode the Gender column
  df$Gender <- factor(df$Gender, levels = c('M', 'F', 'I'), labels = c(0, 1, 2))
  
  # Handle missing values by removing them
  df <- na.omit(df)
  
  return(df)
}

# Step 4: Exploratory Data Analysis
explore_data <- function(df) {
  # Summary statistics
  print(summary(df))
  
  # Plot distribution of Rings (age)
  ggplot(df, aes(x = Rings)) +
    geom_histogram(binwidth = 1, fill = "blue", color = "black") +
    theme_minimal() +
    labs(title = "Distribution of Abalone Age (Rings)", x = "Rings", y = "Frequency")
  
  # Correlation plot
  numeric_columns <- df[, sapply(df, is.numeric)]
  corr_matrix <- cor(numeric_columns)
  corrplot(corr_matrix, method = "circle")
}

# Step 5: Split the data into training and test sets
split_data <- function(df) {
  set.seed(42)
  train_index <- createDataPartition(df$Rings, p = 0.8, list = FALSE)
  train_data <- df[train_index, ]
  test_data <- df[-train_index, ]
  return(list(train = train_data, test = test_data))
}

# Step 6: Train a regression model
train_model <- function(train_data) {
  model <- lm(Rings ~ ., data = train_data)
  summary(model)
  return(model)
}

# Step 7: Evaluate the model
evaluate_model <- function(model, test_data) {
  predictions <- predict(model, newdata = test_data)
  actual <- test_data$Rings
  
  # Calculate Mean Squared Error (MSE)
  mse <- mean((predictions - actual)^2)
  cat("Mean Squared Error:", mse, "\n")
  
  # Plot predicted vs actual values
  ggplot(data.frame(actual, predictions), aes(x = actual, y = predictions)) +
    geom_point(color = 'blue') +
    geom_abline(slope = 1, intercept = 0, color = 'red', linetype = 'dashed') +
    theme_minimal() +
    labs(title = "Predicted vs Actual Rings", x = "Actual Rings", y = "Predicted Rings")
}

# Main function
main <- function() {
  file_path <- "Manya_Gogia_DataModeling.xlsx"  # Replace with your actual file path
  
  # Load and preprocess the data
  df <- load_data(file_path)
  df <- preprocess_data(df)
  
  # Exploratory data analysis
  explore_data(df)
  
  # Split the data into training and testing sets
  data_splits <- split_data(df)
  train_data <- data_splits$train
  test_data <- data_splits$test
  
  # Train the model
  model <- train_model(train_data)
  
  # Evaluate the model
  evaluate_model(model, test_data)
}

# Run the main function
main()
