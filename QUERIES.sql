-- Q1 How many unique customers have visited the store during the time period provided? (To get a sense of the sample size you're working with.)
SELECT 
COUNT(DISTINCT`Customer ID`) AS total_customers
FROM shopping_trends_updated;

-- We have total 3900 Customers	



-- Q2 Should the store stock more male or female clothing? (What % of customers are male vs. female?

WITH DATA AS(
SELECT 
Gender,
COUNT(DISTINCT`Customer ID`) AS total_customers
FROM shopping_trends_updated
GROUP BY Gender)
SELECT 
	sum(total_customers) AS total_customers,
	round(100*(sum(CASE WHEN Gender = 'Female' THEN total_customers ELSE 0 END)/sum(total_customers)),2) AS pct_female,
	round(100*(sum(CASE WHEN Gender = 'Male' THEN total_customers ELSE 0 END)/sum(total_customers)),2) AS pct_male
FROM DATA;		

-- More male customers 2652(68%) - then female customers 1248 (32%)



-- Q3 What seasons are represented in the data? (Helps us track trends by time period.)

SELECT DISTINCT Season FROM	customer_shopping_trends.shopping_trends_updated;

-- Winter - Spring,Summer, Fall



-- Q4 What are the most purchased categories and/or items by season? (This will help guide seasonal stocking strategies.)

SELECT `Category`,
sum(CASE WHEN Season= 'Spring' THEN 1 ELSE 0 END) AS Spring,
sum(CASE WHEN Season= 'Summer' THEN 1 ELSE 0 END) AS Summer,
sum(CASE WHEN Season= 'Fall' THEN 1 ELSE 0 END) AS Fall,
sum(CASE WHEN Season= 'Winter' THEN 1 ELSE 0 END) AS Winter
FROM shopping_trends_updated
GROUP BY `Category`
ORDER BY (Spring + Summer + Fall + Winter) DESC;

-- Most purchased categories across all seasons was CLOTHING and the leaset was OUTWEAR


SELECT 
    Season,
    `Item Purchased`,
    COUNT(*) AS total_purchases

FROM shopping_trends_updated

GROUP BY Season, `Item Purchased`

ORDER BY Season, total_purchases DESC;

-- Most purchased item in FALL - JACKET, SPRING - SWEATER, SUMMER - PANTS, WINTER - SUNGLASSES



-- Q5 What are the most popular item colors by season? (Color preference can affect buying decisions.)

SELECT 
    Season,
    Color,
    COUNT(*) AS total_purchases

FROM shopping_trends_updated

GROUP BY Season, Color

ORDER BY Season, total_purchases DESC;

-- POPULAR COLORS IN FALL - YELLOW, SPRING - OLIVE , SUMMER - SILVER, WINTER - PEACH




-- Q6 Should stocking strategies vary by store location? (You can also explore if customer gender varies by location.)
SELECT 
    Location,
    Category,
    COUNT(*) AS total_purchases

FROM shopping_trends_updated

GROUP BY Location, Category

ORDER BY Location, total_purchases DESC;


SELECT 
    Location,

    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS Male,

    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Female

FROM shopping_trends_updated

GROUP BY Location

ORDER BY (Male + Female) DESC;


-- Different locations show different buying patterns, so inventory should be adjusted based on regional customer preferences.




-- Q7 Which locations are top-performing in terms of customer experience? (Use metrics like frequency of repeat visits or average spend.)

SELECT 
    Location,

    ROUND(AVG(`Purchase Amount (USD)`),2) AS avg_spend,

    ROUND(AVG(`Frequency of Purchases`),2) AS avg_purchase_frequency,

    ROUND(AVG(`Review Rating`),2) AS avg_review_rating

FROM shopping_trends_updated

GROUP BY Location

ORDER BY avg_purchase_frequency DESC,
         avg_spend DESC,
         avg_review_rating DESC;
         
-- West Virginia, Nevada, and Washington appear to be the top-performing locations based on higher average spending and strong customer review ratings.



-- Q8 Does having more than 10 previous purchases correlate with higher total spend? (Understanding customer loyalty and value.)
SELECT 
    CASE 
        WHEN `Previous Purchases` > 10 THEN 'More than 10 Purchases'
        ELSE '10 or Fewer Purchases'
    END AS customer_group,

    ROUND(AVG(`Purchase Amount (USD)`),2) AS avg_spend,

    COUNT(*) AS total_customers

FROM shopping_trends_updated

GROUP BY customer_group;

-- Customers with more than 10 previous purchases do not show higher spending, as their average spend is slightly lower than customers with 10 or fewer purchases.
