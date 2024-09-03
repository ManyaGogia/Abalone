# abalone_analysis.py

import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
import numpy as np

# Step 1: Load Data
def load_data(file_path):
    # Read the Excel file into a pandas DataFrame
    df = pd.read_excel(file_path, sheet_name='Original Data')
    # Rename columns based on the header row
    df.columns = df.iloc[1]
    # Drop the first two rows as they are headers
    df = df.drop([0, 1]).reset_index(drop=True)
    return df

# Step 2: Preprocess Data
def preprocess_data(df):
    # Convert numerical columns to appropriate types
    numeric_columns = ['Length', 'Diameter', 'Height', 'Whole_weight', 'Shucked_weight', 'Viscera_weight', 'Shell_weight', 'Rings']
    df[numeric_columns] = df[numeric_columns].apply(pd.to_numeric, errors='coerce')

    # Encode categorical data (Gender)
    le = LabelEncoder()
    df['Gender'] = le.fit_transform(df['Gender'])

    # Handle missing values (if any)
    df = df.dropna()

    # Separate features and target variable
    X = df[['Gender', 'Length', 'Diameter', 'Height', 'Whole_weight', 'Shucked_weight', 'Viscera_weight', 'Shell_weight']]
    y = df['Rings'].astype(int)  # Target variable (Rings as a measure of age)

    # Scale features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    return X_scaled, y

# Step 3: Train-Test Split
def split_data(X, y):
    return train_test_split(X, y, test_size=0.2, random_state=42)

# Step 4: Model Building
def train_model(X_train, y_train):
    model = LinearRegression()
    model.fit(X_train, y_train)
    return model

# Step 5: Evaluate Model
def evaluate_model(model, X_test, y_test):
    y_pred = model.predict(X_test)
    mse = mean_squared_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)
    print(f"Mean Squared Error: {mse}")
    print(f"R^2 Score: {r2}")

# Main function
def main():
    # Load and preprocess data
    file_path = 'Manya_Gogia_DataModeling.xlsx'  # Replace with your actual file path
    df = load_data(file_path)
    X, y = preprocess_data(df)
    
    # Split the data
    X_train, X_test, y_train, y_test = split_data(X, y)
    
    # Train the model
    model = train_model(X_train, y_train)
    
    # Evaluate the model
    evaluate_model(model, X_test, y_test)

if __name__ == "__main__":
    main()
