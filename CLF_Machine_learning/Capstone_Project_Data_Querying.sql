-- QUERY 0 ----------

SELECT * FROM AutoInsurance.autoinsurance;

-- QUERY 1 ----------


SELECT Coverage, COUNT(Coverage) FROM  AutoInsurance.autoinsurance
GROUP BY Coverage;

-- QUERY 2 ----------


SELECT Response, COUNT(Response) FROM  AutoInsurance.autoinsurance
GROUP BY Response;

-- QUERY 3 ----------


SELECT Education, COUNT(Education) FROM  AutoInsurance.autoinsurance
GROUP BY Education;

-- QUERY 4 ----------


SELECT EmploymentStatus, COUNT(EmploymentStatus) FROM  AutoInsurance.autoinsurance
GROUP BY EmploymentStatus;

-- QUERY 5----------


SELECT Gender, COUNT(Gender) FROM  AutoInsurance.autoinsurance
GROUP BY Gender;

-- QUERY 6 ----------


SELECT  `Marital_Status`, COUNT( `Marital_Status`) FROM  AutoInsurance.autoinsurance
GROUP BY  `Marital_Status`;

-- QUERY 7 ----------


SELECT `Policy_Type`, COUNT(`Policy_Type`) FROM  AutoInsurance.autoinsurance
GROUP BY `Policy_Type`;

-- QUERY 8 ----------


SELECT Policy, COUNT(Policy) FROM  AutoInsurance.autoinsurance
GROUP BY Policy;

-- QUERY 9 ----------


SELECT `Renew_Offer_Type`, COUNT(`Renew_Offer_Type`) FROM  AutoInsurance.autoinsurance
GROUP BY `Renew_Offer_Type`;

-- QUERY 10 ----------


SELECT `Sales_Channel`, COUNT(`Sales_Channel`) FROM  AutoInsurance.autoinsurance
GROUP BY `Sales_Channel`;

-- QUERY 11 ---------- Gives the number of unique combinations of entries in the dataset


SELECT Response, Coverage, Education, EmploymentStatus, Gender,  `Marital_Status`, Policy, `Policy_Type`, `Renew_Offer_Type`, `Sales_Channel`, COUNT(`Sales_Channel`) AS `Count` FROM  AutoInsurance.autoinsurance
GROUP BY Response, Coverage, Education, EmploymentStatus, Gender,  `Marital_Status`, Policy, `Policy_Type`, `Renew_Offer_Type`, `Sales_Channel`;

-- QUERY 12 ---------- Monthly Premium and Claim by Gender

SELECT Gender, AVG(`Monthly_Premium_Auto`) AS Average_Premium, AVG(`Total_Claim_Amount`) AS Total_Claim
FROM AutoInsurance.autoinsurance
GROUP BY Gender
ORDER By Gender, Average_Premium;

-- QUERY 13 ---------- Monthly Premium and Claim by Employment Status

SELECT EmploymentStatus, AVG(`Monthly_Premium_Auto`) AS Average_Premium, AVG(`Total_Claim_Amount`) AS Total_Claim
FROM AutoInsurance.autoinsurance
GROUP BY EmploymentStatus
ORDER By Average_Premium;

-- QUERY 14 ---------- Monthly Premium and Claim by Gender and Employment Status

SELECT Gender, EmploymentStatus, AVG(`Monthly_Premium_Auto`) AS Average_Premium, AVG(`Total_Claim_Amount`) AS Total_Claim
FROM AutoInsurance.autoinsurance
GROUP BY Gender, EmploymentStatus
ORDER By Gender, Average_Premium;

-- QUERY 15 ---------- Customer Lifetime Value and Claim by Number of Months since last claim

SELECT `Months_Since_Last_Claim`, AVG(`Total_Claim_Amount`) AS Total_Claim_Avg, AVG(`Customer_Lifetime_Value`) AS CLV_Avg
FROM AutoInsurance.autoinsurance
GROUP BY `Months_Since_Last_Claim`
ORDER BY `Months_Since_Last_Claim`;

-- QUERY 16 ---------- Customer Lifetime Value and Claim by Response 

SELECT Response, AVG(`Total_Claim_Amount`) AS Total_Claim_Avg, AVG(`Customer_Lifetime_Value`) AS CLV_Avg
FROM AutoInsurance.autoinsurance
GROUP BY Response;

-- QUERY 17 ---------- Customer Lifetime Value and Claim by Response and Number of Months since last claim

SELECT Response, `Months_Since_Last_Claim`, AVG(`Total_Claim_Amount`) AS Total_Claim_Avg, AVG(`Customer_Lifetime_Value`) AS CLV_Avg
FROM AutoInsurance.autoinsurance
GROUP BY Response, `Months_Since_Last_Claim`
ORDER BY `Months_Since_Last_Claim`;

-- QUERY 18 ---------- Customer Lifetime Value based on Education

SELECT Education, AVG(`Customer_Lifetime_Value`) AS CLV_Avg
FROM AutoInsurance.autoinsurance
GROUP BY Education;

-- QUERY 19 ---------- Customer Lifetime Value based on Coverage

SELECT Coverage, AVG(`Customer_Lifetime_Value`) AS CLV_Avg
FROM AutoInsurance.autoinsurance
GROUP BY Coverage;

-- QUERY 20 ---------- Customer Lifetime Value based on Number of policies

SELECT `Number_of_Policies`, AVG(`Customer_Lifetime_Value`) AS CLV_Avg
FROM AutoInsurance.autoinsurance
GROUP BY `Number_of_Policies`
ORDER BY `Number_of_Policies`;

-- QUERY 21 ---------- Customer Lifetime Value based on Number of policies and Coverage

SELECT `Number_of_Policies`, Coverage, AVG(`Customer_Lifetime_Value`) AS CLV_Avg
FROM AutoInsurance.autoinsurance
GROUP BY `Number_of_Policies`, Coverage
ORDER BY Coverage;

-- QUERY 22 ---------- 
SELECT STATE,AVG(`Customer_Lifetime_Value`) AS CLV_avg FROM AutoInsurance.autoinsurance
WHERE `Number_of_Policies` = 2 AND Coverage != "Extended"
GROUP BY STATE;

-- QUERY 23 ---------- 
SELECT STATE, Coverage, AVG(`Customer_Lifetime_Value`) AS CLV_avg FROM AutoInsurance.autoinsurance
WHERE `Number_of_Policies` = 2 AND Coverage != "Extended"
GROUP BY STATE, Coverage;

-- QUERY 24 ---------- 
SELECT STATE,  AVG(`Customer_Lifetime_Value`) AS CLV_avg FROM AutoInsurance.autoinsurance
GROUP BY STATE;

-- QUERY 25 ----------

SELECT State, AVG(`Monthly_Premium_Auto`) AS Monthly_Premium FROM AutoInsurance.autoinsurance
GROUP BY State;

-- QUERY 26 ---------- 
SELECT STATE, Coverage, AVG(`Customer_Lifetime_Value`) AS CLV_avg FROM AutoInsurance.autoinsurance
GROUP BY STATE, Coverage;

-- QUERY 27 ----------

SELECT State, AVG(`Monthly_Premium_Auto`) AS Monthly_Premium, AVG(`Customer_Lifetime_Value`) AS CLV_avg 
FROM AutoInsurance.autoinsurance
GROUP BY State;

-- QUERY 28 ---------- 
SELECT STATE, Coverage, AVG(`Monthly_Premium_Auto`) AS Monthly_Premium, AVG(`Customer_Lifetime_Value`) AS CLV_avg 
FROM AutoInsurance.autoinsurance
GROUP BY STATE, Coverage
ORDER BY Monthly_Premium;

-- QUERY 29 ---------- 
SELECT MAX(`Customer_Lifetime_Value`), MIN(`Customer_Lifetime_Value`)
FROM AutoInsurance.autoinsurance;

-- QUERY 30 ----------
SELECT EmploymentStatus, MAX(`Customer_Lifetime_Value`) AS `Maximum CLV`, MIN(`Customer_Lifetime_Value`) AS `Minimum CLV`
FROM AutoInsurance.autoinsurance
GROUP BY EmploymentStatus;
