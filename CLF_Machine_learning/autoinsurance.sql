CREATE DATABASE AutoInsurance;

CREATE TABLE AutoInsurance.autoinsurance (
Customer VARCHAR(7),State VARCHAR(20),Customer_Lifetime_Value DOUBLE,Response VARCHAR(3),Coverage VARCHAR(10),Education VARCHAR(30), 
Effective_To_Date DATE,EmploymentStatus VARCHAR(15),Gender VARCHAR(6),Income LONG,Location_Code VARCHAR(15),Marital_Status VARCHAR(15),
Monthly_Premium_Auto INT,Months_Since_Last_Claim INT,Months_Since_Policy_Inception INT,Number_of_Open_Complaints INT,
Number_of_Policies INT,Policy_Type VARCHAR(30),Policy VARCHAR(30),Renew_Offer_Type VARCHAR(10),Sales_Channel VARCHAR(15),Total_Claim_Amount DOUBLE,
Vehicle_Class VARCHAR(25),Vehicle_Size VARCHAR(10)
);

# Uploaded data from the AutoInsurance.csv using the Table import Wizard

# TRUNCATE TABLE AutoInsurance.autoinsurance;
# DROP TABLE AutoInsurance.autoinsurance;

# Data can be loaded into the database with the following code also!
LOAD DATA INFILE 'file_path'
INTO TABLE AutoInsurance.autoinsurance
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM autoinsurance;

SHOW COLUMNS FROM autoinsurance;

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'AutoInsurance' AND TABLE_NAME = 'autoinsurance';

