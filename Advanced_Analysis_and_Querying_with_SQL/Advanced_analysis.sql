

/* 1. Customer Segmentation 
Segment customers based on their Customer_Lifetime_Value into categories \
such as ‘Risky’, ‘Neutral’,'Safe', and ‘Exceptional’. Identify which customers fall into each category \
and analyze their characteristics */

WITH Segments AS (
SELECT Customer, Customer_Lifetime_Value, 
NTILE(4) OVER (ORDER BY Customer_Lifetime_Value) AS Segment
FROM autoinsurance
),
table_new AS (
SELECT s.Customer_Lifetime_Value, s.Segment, State, Coverage, Education, EmploymentStatus, Gender, Income, 
Location_Code,Marital_Status,Monthly_Premium_Auto, Months_Since_Last_Claim, Months_Since_Policy_Inception, 
Number_of_Open_Complaints, Number_of_Policies,Total_Claim_Amount, Vehicle_Class, Vehicle_Size
FROM autoinsurance AS ai
LEFT JOIN Segments AS s
ON ai.Customer = s.Customer
),
ratings AS (
SELECT Customer_Lifetime_Value, Segment, State, Coverage, Education, EmploymentStatus, Gender, Income, 
Location_Code,Marital_Status,Monthly_Premium_Auto, Months_Since_Last_Claim, Months_Since_Policy_Inception, 
Number_of_Open_Complaints, Number_of_Policies,Total_Claim_Amount, Vehicle_Class, Vehicle_Size,
CASE 
	WHEN Segment = 1 THEN "Risky"
    WHEN Segment = 2 THEN "Neutral"
    WHEN Segment = 3 THEN "Safe"
    WHEN Segment = 4 THEN "Exceptional"
    END AS Customer_rating
FROM table_new
)
-- SELECT * FROM ratings;
SELECT Customer_rating, Segment, COUNT(Customer_rating)AS Number_of_Customers FROM ratings
GROUP BY Customer_rating, Segment
ORDER BY Segment;

/*2. Customer Retention Analysis
Identify customers who have not made a claim in the last 12 months and have had their policies for more than 24 months. 
How does this number look by Gender, Education, MaritalStatus, Income class, and Employment Status?
*/

WITH income_classes AS (
SELECT Customer, income,
NTILE(4) OVER (ORDER BY income) AS income_quartiles
FROM autoinsurance
),
Segments AS (
SELECT Customer, Customer_Lifetime_Value, 
NTILE(4) OVER (ORDER BY Customer_Lifetime_Value) AS Segment
FROM autoinsurance
)

SELECT Education, Gender, Marital_Status, EmploymentStatus,i.income_quartiles,s.Segment,
COUNT(Education) AS Number_of_customers FROM autoinsurance
JOIN income_classes AS i
ON autoinsurance.Customer = i.Customer
JOIN Segments AS s
ON autoinsurance.Customer = s.Customer
WHERE Months_Since_Last_Claim > 12 AND Months_Since_Policy_Inception > 24
GROUP BY Education, Gender, i.income_quartiles, s.Segment, Marital_Status, EmploymentStatus
ORDER BY Number_of_customers DESC, i.income_quartiles, s.Segment;

/*3. Sales Channel Performance
Compare the average monthly premium for auto insurance across different sales channels. 
Which channels tend to bring in higher premiums?*/

SELECT Sales_Channel, COUNT(Customer) as Number_of_Customers, AVG(Monthly_Premium_Auto) AS Average_Premium,
(COUNT(Customer)*AVG(Monthly_Premium_Auto)) AS Total_Premium
FROM autoinsurance
GROUP BY Sales_Channel;

/*4. Claims Analysis
Determine which customers have filed claims totaling over a significant amount, such as $10,000. 
What are the patterns or trends among these high-claim customers?*/

SELECT * FROM autoinsurance
WHERE Total_Claim_Amount>2000;

/*5. Policy Analysis
Explore the popularity of different policy types among customers with various income levels. 
How does income influence the choice of policy type?*/

WITH income_classes AS (
SELECT Customer, income,
NTILE(4) OVER (ORDER BY income) AS income_quartiles
FROM autoinsurance
)
SELECT Policy_Type, i.income_quartiles, COUNT(Policy_Type) AS Number_of_Customers
FROM autoinsurance AS ai
JOIN income_classes AS i
ON ai.Customer = i.Customer
GROUP BY Policy_Type, i.income_quartiles
ORDER BY Number_of_Customers DESC;

/*6. Response Rate by Demographic
Analyze the response rates to marketing based on customers’ education levels and gender. 
Which demographic groups have the highest and lowest response rates?*/


SELECT Response, Education, Gender, (COUNT(Response)/(SELECT COUNT(Response) FROM autoinsurance)*100) AS Percentage_of_customers FROM autoinsurance
GROUP BY Response, Education, Gender
ORDER BY Percentage_of_customers DESC;

/*7. Insurance Coverage Analysis
Examine the distribution of insurance coverage types across different states. 
Which coverage types are most popular in each state?*/

SELECT State, Coverage, COUNT(Coverage)/9134*100 AS Percentage_of_Customers
FROM autoinsurance
GROUP BY State, Coverage
ORDER BY State, Coverage, Percentage_of_Customers DESC;

/*8. Customer Complaints
Calculate the average number of open complaints associated with each policy type. 
Identify which policy types tend to have the highest and lowest average number of complaints.*/

SELECT Policy_Type, AVG(Number_of_Open_Complaints) AS Average_Open_Complaints
FROM autoinsurance
GROUP BY Policy_Type
ORDER BY Average_Open_Complaints DESC;

/*9. Monthly Premium Trend
Investigate how the average monthly premium for auto insurance varies with the location and coverage. 
What can you say about living in a rural area and taking a premium policy versus living in an urban area and taking a basic policy?*/

SELECT Location_Code, Coverage, AVG(Monthly_Premium_Auto) AS Average_Premium
FROM autoinsurance
GROUP BY Location_Code, Coverage
ORDER BY Location_Code, Coverage, Average_Premium DESC;

/*10. Vehicle Class and Size Analysis
Explore the distribution of different vehicle classes and sizes among customers. 
How do vehicle class and size vary across the customer base?*/

SELECT Vehicle_Class, Vehicle_Size, COUNT(Customer) AS Number_of_Customers
FROM autoinsurance
GROUP BY Vehicle_Class, Vehicle_Size
ORDER BY Number_of_Customers DESC;

/*11. Customer Ranking by Lifetime Value
Rank the customers within each state based on their Customer_Lifetime_Value.*/

SELECT Customer, State, Customer_Lifetime_Value,
RANK() OVER (PARTITION BY State ORDER BY Customer_Lifetime_Value) AS Rank_CLV
FROM autoinsurance;

/*12. Difference in Customer Lifetime Value
Find the difference in Customer_Lifetime_Value between consecutive customers based on their rank in each state.*/

WITH rank_cte AS (
SELECT Customer, State, Customer_Lifetime_Value,
RANK() OVER (PARTITION BY State ORDER BY Customer_Lifetime_Value) AS Rank_CLV
FROM autoinsurance
)
SELECT State,Rank_CLV,Customer_Lifetime_Value,
LEAD(Customer_Lifetime_Value,1) OVER (ORDER BY State, Rank_CLV, Customer_Lifetime_Value) - Customer_Lifetime_Value AS Difference 
FROM rank_cte;

/*13. Average Premium by Employment Status and Education
Calculate the average Monthly_Premium_Auto for each combination of EmploymentStatus and Education, 
showing the average over all rows with the same employment and education status.*/

SELECT EmploymentStatus, Education,
AVG(Monthly_Premium_Auto) OVER (PARTITION BY EmploymentStatus, Education ORDER BY EmploymentStatus, Education)
AS Average_Premium
FROM autoinsurance
ORDER BY Average_Premium DESC;

/*14. Percentage of Total Claims by Customer
Compute the percentage of the Total_Claim_Amount for each customer out of the total claims for their state.*/

SELECT Customer, State, Total_Claim_Amount/SUM(Total_Claim_Amount) OVER (PARTITION BY State)*100 AS
Percent_Claim_Per_Customer_By_State
FROM autoinsurance
ORDER BY Percent_Claim_Per_Customer_By_State DESC;

/*15. Identify Top N Customers by Lifetime Value per State
List the top 3 customers by Customer_Lifetime_Value in each state.*/

-- OPTION 1 with RANK() with repetition of ranks
SELECT Customer, State, Customer_Lifetime_Value, State_ranks
FROM (
SELECT Customer, State, Customer_Lifetime_Value,
RANK() OVER (PARTITION BY State ORDER BY Customer_Lifetime_Value) AS State_ranks
FROM autoinsurance) AS ranks
WHERE State_ranks<=3;

-- OPTION 2 With ROW_NUMBER() to avoid repetition of ranks
SELECT Customer, State, Customer_Lifetime_Value, State_ranks
FROM (
SELECT Customer, State, Customer_Lifetime_Value,
ROW_NUMBER() OVER (PARTITION BY State ORDER BY Customer_Lifetime_Value) AS State_ranks
FROM autoinsurance) AS ranks
WHERE State_ranks<=3;

/*16. Identify Outliers in Claims Amount
Find customers with Total_Claim_Amount significantly higher than the average 
(e.g., more than 1.5 times the interquartile range above the third quartile).*/

WITH Quartiles AS (
SELECT Customer, Total_Claim_Amount,
NTILE(4) OVER (ORDER BY Total_Claim_Amount) AS Quartile
FROM autoinsurance
),
interquartiles AS (
SELECT
MAX(CASE WHEN Quartile = 1 THEN Total_Claim_Amount ELSE NULL END) AS Q1, 
MAX(CASE WHEN Quartile = 3 THEN Total_Claim_Amount ELSE NULL END) AS Q3
FROM Quartiles
),
outliers as (
SELECT Customer, Total_Claim_Amount, Q1, Q3,
(Q3 - Q1) * 1.5 AS IQR,
CASE WHEN Total_Claim_Amount > Q3 + (Q3 - Q1) * 1.5 THEN 'Outlier' ELSE 'Acceptable' END AS Outlier_Status
FROM interquartiles, Quartiles
)
SELECT Customer, Total_Claim_Amount,Outlier_Status
FROM outliers
WHERE Outlier_Status != "Outlier";