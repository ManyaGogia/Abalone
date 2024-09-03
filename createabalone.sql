-- abalone_project.sql

-- Step 1: Create a table to store abalone data
CREATE TABLE Abalone (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Gender CHAR(1),                 -- 'M' for male, 'F' for female, 'I' for infant
    Length FLOAT,                   -- Length of the abalone (mm)
    Diameter FLOAT,                 -- Diameter of the abalone (mm)
    Height FLOAT,                   -- Height of the abalone (mm)
    Whole_weight FLOAT,             -- Whole weight of the abalone (grams)
    Shucked_weight FLOAT,           -- Weight of the abalone's meat (grams)
    Viscera_weight FLOAT,           -- Gut weight (after bleeding) (grams)
    Shell_weight FLOAT,             -- Shell weight (grams)
    Rings INT                       -- Number of rings (used to estimate age)
);

-- Step 2: Insert sample data into the Abalone table
INSERT INTO Abalone (Gender, Length, Diameter, Height, Whole_weight, Shucked_weight, Viscera_weight, Shell_weight, Rings)
VALUES 
('M', 0.455, 0.365, 0.095, 0.5140, 0.2245, 0.1010, 0.150, 15),
('F', 0.525, 0.420, 0.140, 0.6770, 0.2565, 0.1415, 0.210, 9),
('I', 0.440, 0.365, 0.125, 0.5160, 0.2155, 0.1140, 0.155, 10),
('M', 0.545, 0.425, 0.125, 0.7680, 0.2940, 0.1845, 0.260, 19),
('F', 0.475, 0.370, 0.125, 0.5095, 0.2165, 0.1125, 0.165, 11);

-- Step 3: Basic queries for analysis

-- Query 1: Calculate the average age of abalones (Rings + 1.5 years is the standard estimate for age)
SELECT AVG(Rings + 1.5) AS Average_Age FROM Abalone;

-- Query 2: Count the number of abalones by gender
SELECT Gender, COUNT(*) AS Number_Of_Abalones
FROM Abalone
GROUP BY Gender;

-- Query 3: Find the maximum, minimum, and average weight of abalones
SELECT 
    MAX(Whole_weight) AS Max_Weight,
    MIN(Whole_weight) AS Min_Weight,
    AVG(Whole_weight) AS Avg_Weight
FROM Abalone;

-- Query 4: List abalones with more than 10 rings (potentially older abalones)
SELECT * FROM Abalone
WHERE Rings > 10;

-- Query 5: Find the correlation between length and shell weight (this would typically require more advanced analysis)
-- This query is a placeholder, as SQL does not natively calculate correlations
-- Placeholder query: Select abalones sorted by length
SELECT * FROM Abalone
ORDER BY Length DESC;

-- Step 4: Create indexes to optimize common queries (e.g., by Gender and Rings)
CREATE INDEX idx_gender ON Abalone (Gender);
CREATE INDEX idx_rings ON Abalone (Rings);
