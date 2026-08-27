-- 1. Import the dataset and do usual exploratory analysis steps like checking the structure & characteristics of the dataset:

-- a. Data type of all columns in the "customers" table.

select *
from SQL_TARGET.customers;

select *
from `SQL_TARGET.products`
limit 10;


-- b. Get the time range between which the orders were placed.

select 
  min(order_purchase_timestamp) as start_time,
  max(order_purchase_timestamp) as end_time
from `SQL_TARGET.orders`;


-- c. Count the Cities & States of customers who ordered during the given period(Year is 2018 AND Months from January to June).

select 
  count(distinct ord.customer_id) as no_of_customer,
  count(distinct cus.customer_state) as no_of_states,
  count(distinct cus.customer_city) as no_of_cities
from `SQL_TARGET.customers` as cus
join `SQL_TARGET.orders` as ord
on cus.customer_id = ord.customer_id
WHERE EXTRACT(YEAR FROM ORD.ORDER_PURCHASE_TIMESTAMP) = 2018
      AND 
      EXTRACT(MONTH FROM ORD.ORDER_PURCHASE_TIMESTAMP) IN (1,2,3,4,5,6);


-- 2. In-depth Exploration:

-- a. Is there a growing trend in the no. of orders placed over the past years?

  -- Case 1: Growing trend for each month of each year:
  SELECT 
    EXTRACT(YEAR FROM ORDER_PURCHASE_TIMESTAMP) AS YEAR,
    EXTRACT(MONTH FROM ORDER_PURCHASE_TIMESTAMP) AS MONTH,
    COUNT(ORDER_ID) AS NO_OF_ORDERS
    -- LAG(COUNT(ORDER_ID), 1,0) OVER (PARTITION BY EXTRACT(YEAR FROM ORDER_PURCHASE_TIMESTAMP),EXTRACT(MONTH FROM ORDER_PURCHASE_TIMESTAMP) 
    -- ORDER BY EXTRACT(YEAR FROM ORDER_PURCHASE_TIMESTAMP), EXTRACT(MONTH FROM ORDER_PURCHASE_TIMESTAMP)) AS prev_MONTH_ORDERS
  FROM `SQL_TARGET.orders`
  GROUP BY 1,2
  ORDER BY 1,2;

  -- Case 2: Growing trend for each year:

  SELECT 
    EXTRACT(YEAR FROM ORDER_PURCHASE_TIMESTAMP) AS YEAR,
    COUNT(ORDER_ID) AS No_Of_Orders
  FROM `SQL_TARGET.orders`
  GROUP BY 1
  ORDER BY 1;

  -- Case 3: Growing trend for month-wise:

  SELECT 
    (EXTRACT(MONTH FROM ORDER_PURCHASE_TIMESTAMP)) AS MONTH,
    COUNT(ORDER_ID) AS No_Of_Orders
  FROM `SQL_TARGET.orders`
  GROUP BY 1
  ORDER BY 2 DESC;


-- b. Can we see some kind of monthly seasonality in terms of the no. of
-- orders being placed?

SELECT "August\nMay\nJuly" AS months_with_Highest_sales;


--  c. During what time of the day, do the Brazilian(brasileia) customers mostly place
--  their orders? (Dawn, Morning, Afternoon or Night)
--  ■ 0-6 hrs : Dawn
--  ■ 7-12 hrs : Mornings
--  ■ 13-18 hrs : Afternoon
--  ■ 19-23 hrs : Night

/*
CITIES WHICH FALLS UNDER BRAZIL ARE:
1	rio branco
2	senador guiomard
3	porto acre
4	xapuri
5	brasileia
6	epitaciolandia
7	manoel urbano
8	cruzeiro do sul
*/

SELECT 
  CASE
    WHEN EXTRACT(HOUR FROM o.ORDER_PURCHASE_TIMESTAMP) BETWEEN 0 AND 6 THEN 'DAWN'
    WHEN EXTRACT(HOUR FROM o.ORDER_PURCHASE_TIMESTAMP) BETWEEN 7 AND 12 THEN 'MORNING'
    WHEN EXTRACT(HOUR FROM o.ORDER_PURCHASE_TIMESTAMP) BETWEEN 13 AND 18 THEN 'AFTERNOON'
    ELSE 'NIGHT'
  END AS TIME_ORDER,
  COUNT(*) AS NO_OF_ORDERS
FROM `SQL_TARGET.orders` as o
join `SQL_TARGET.customers` as cu
on cu.customer_id = o.customer_id
WHERE cu.customer_city IN ('rio branco',	'senador guiomard',	'porto acre',	'xapuri',	'brasileia',	'epitaciolandia',	'manoel urbano',	'cruzeiro do sul')
GROUP BY 1
ORDER BY 2 DESC;



-- 3. Evolution of E-commerce orders in the Brazil region:
  -- a. Get the month on month no. of orders placed in each state.
  -- b. How are the customers distributed across all the states?

-- a. Get the month on month no. of orders placed in each state.

-- CASE 1. MONTH-WISE NUMBER OF ORDERS:
SELECT 
  C.customer_state,
  EXTRACT(MONTH FROM O.ORDER_PURCHASE_TIMESTAMP) AS MONTH_OF_ORDER,
  COUNT(O.ORDER_ID) AS NO_OF_ORDERS
FROM `SQL_TARGET.orders` AS O
JOIN `SQL_TARGET.customers` AS C
ON C.customer_id = O.customer_id
GROUP BY 1,2
ORDER BY 1,2;

-- CASE 2. YEAR-MONTH WISE NUMBER OF ORDERS:
SELECT 
  C.CUSTOMER_STATE,
  EXTRACT(YEAR FROM O.ORDER_PURCHASE_TIMESTAMP)AS YEAR_ORDERS,
  EXTRACT(MONTH FROM O.ORDER_PURCHASE_TIMESTAMP)AS MONTH_ORDERS,
  COUNT(O.ORDER_ID) AS NO_OF_ORDERS
FROM `SQL_TARGET.orders` AS O
JOIN `SQL_TARGET.customers` AS C 
ON O.CUSTOMER_ID = C.customer_id
GROUP BY 1,2,3
ORDER BY 2,3;


-- b. How are the customers distributed across all the states?

SELECT
  customer_state,customer_city,
  COUNT(customer_id) AS NO_OF_CUSTOMRES
FROM `SQL_TARGET.customers`
GROUP BY 1,2
ORDER BY 3 DESC;



-- 4. Impact on Economy: Analyze the money movement by e-commerce by looking at order prices, freight and others.

-- a. Get the % increase in the cost of orders from year 2017 to 2018 (include months between Jan to Aug only).
-- You can use the "payment_value" column in the payments table to get
-- the cost of orders.

WITH YEARLY_TOTAL
AS (
  SELECT 
  EXTRACT(YEAR FROM O.ORDER_PURCHASE_TIMESTAMP) AS YEAR_ORDER,
  ROUND(SUM(PT.PAYMENT_VALUE),2) AS SUM_OF_ORDERS
FROM `SQL_TARGET.orders` AS O
JOIN `SQL_TARGET.payments` AS PT 
ON O.order_id = PT.order_id 
WHERE EXTRACT(YEAR FROM O.ORDER_PURCHASE_TIMESTAMP) IN (2017,2018) 
      AND
      EXTRACT(MONTH FROM O.ORDER_PURCHASE_TIMESTAMP) BETWEEN 1 AND 8
GROUP BY 1
),
YEARLY_COMPARISION 
 AS (
  SELECT 
  *,
  LEAD(SUM_OF_ORDERS) OVER(ORDER BY YEAR_ORDER DESC) AS PREV_YEAR_DIFFERENCE
 FROM YEARLY_TOTAL
)

SELECT *,
  ROUND(((SUM_OF_ORDERS -PREV_YEAR_DIFFERENCE)/PREV_YEAR_DIFFERENCE)*100,2)
FROM YEARLY_COMPARISION;


-- b. Calculate the Total & Average value of order price for each state.

SELECT *
FROM `SQL_TARGET.orders`;

SELECT * 
FROM `SQL_TARGET.order_items`;

SELECT 
  CU.customer_state AS STATE,
  ROUND(SUM(OT.price),2) AS TOTAL_ORDER_PRICE,
  COUNT(O.order_id) AS NO_OF_ORDERS,
  ROUND(AVG(OT.price),2) AS AVERAGE_ORDER_PRICE
FROM `SQL_TARGET.customers` AS CU
JOIN `SQL_TARGET.orders` AS O  
ON CU.customer_id = O.customer_id
JOIN `SQL_TARGET.order_items` AS OT
ON OT.order_id = O.order_id
GROUP BY 1;


-- c. Calculate the Total & Average value of order freight for each state.

SELECT * FROM `SQL_TARGET.geolocation`;

SELECT * FROM `SQL_TARGET.order_items`;


SELECT 
  CU.CUSTOMER_STATE AS STATE,
  ROUND(SUM(OT.freight_value),2) AS TOTAL_FREIGHT_VALUE,
  COUNT(OT.freight_value) AS NO_OF_FREIGHT_VALUE,
  ROUND(AVG(OT.freight_value),2) AS AVG_FREIGHT_VALUE
FROM `SQL_TARGET.customers` AS CU
JOIN `SQL_TARGET.orders` AS O
ON CU.customer_id = O.customer_id
JOIN `SQL_TARGET.order_items` AS OT
ON OT.order_id = O.order_id
GROUP BY 1;


-- 5. Analysis based on sales, freight and delivery time.

-- a. Find the no. of days taken to deliver each order from the order’s purchase date as delivery time.
-- Also, calculate the difference (in days) between the estimated & actual delivery date of an order.
-- Do this in a single query.
-- You can calculate the delivery time and the difference between the estimated & actual delivery date using the given formula:
  -- ■ time_to_deliver = order_delivered_customer_date - order_purchase_timestamp
  -- ■ diff_estimated_delivery = order_delivered_customer_date - order_estimated_delivery_date

SELECT 
ORDER_ID,
DATE_DIFF(DATE(order_delivered_customer_date),DATE(order_purchase_timestamp),DAY) AS TIME_OF_DELIVERY,
DATE_DIFF(DATE(order_delivered_customer_date),DATE(order_estimated_delivery_date),DAY) AS DIFF_ESTIMATED_DELIVERY
FROM `SQL_TARGET.orders`;

/*
IF DIFF_ESTIMATED_DELIVERY IS NEGATIVE(-VE), THEN THE ORDER HAS ARRIVED BEFORE ESTIMATED DATE.
IF DIFF_ESTIMATED_DELIVERT IS POSITIVE(+VE), THEN THE ORDER HAS ARRIVED AFTER ESTIMATED DATE.
IF DIFF_ESTIMATED_DELIVERY IS ZERO(0), THEN THE ORDER HAS ARRIVED ON ESTIMATES DATE.
*/


-- b. Find out the top 5 states with the highest & lowest average freight value.

-- CASE 1: TOP 5 STATES WITH HIGHEST AVERAGE FREIGHT VALUE:

SELECT 
  CU.customer_state,
  ROUND(AVG(OI.freight_value),2) AS AVG_FREIGHT_VALUE
FROM `SQL_TARGET.customers` AS CU
JOIN `SQL_TARGET.orders` AS O 
ON O.customer_id = CU.customer_id
JOIN `SQL_TARGET.order_items` AS OI
ON OI.ORDER_ID = O.order_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- CASE 2: TOP 5 STATES WITH LOWEST AVERAGE FREIGHT VALUE:

SELECT 
  CU.CUSTOMER_STATE,
  ROUND(AVG(OI.freight_value),2) AS AVG_FREIGHT_VALUE
FROM `SQL_TARGET.customers` AS CU
JOIN `SQL_TARGET.orders` AS O 
ON O.customer_id = CU.customer_id
JOIN `SQL_TARGET.order_items` AS OI
ON OI.ORDER_ID = O.order_id
GROUP BY 1
ORDER BY 2
LIMIT 5;


-- c. Find out the top 5 states with the highest & lowest average delivery time.


-- CASE 1: TOP 5 STATES WITH HIGHEST AVERAGE DELIVERY TIME(IN DAYS):
SELECT 
  CU.customer_state,
  ROUND(AVG(
    DATE_DIFF(
              EXTRACT(DATE FROM O.ORDER_DELIVERED_CUSTOMER_DATE),
              EXTRACT(DATE FROM O.ORDER_PURCHASE_TIMESTAMP),
              DAY
            )
  ),2) AS AVG_DELIVERY_DAYS
FROM `SQL_TARGET.orders` AS O 
JOIN `SQL_TARGET.customers` AS CU 
ON CU.customer_id = O.customer_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- CASE 2: TOP 5 STATES WITH LOWEST AVERAGE DELIVERY TIME(IN DAYS):
SELECT
  CU.customer_state,
  ROUND(
      AVG(
        DATE_DIFF(EXTRACT(DATE FROM O.ORDER_DELIVERED_CUSTOMER_DATE),
                  EXTRACT(DATE FROM O.ORDER_PURCHASE_TIMESTAMP)
          ,DAY)
      )
    ,2)
FROM `SQL_TARGET.customers` AS CU 
JOIN `SQL_TARGET.orders` AS O   
ON O.CUSTOMER_ID = CU.CUSTOMER_ID
GROUP BY 1
ORDER BY 2
LIMIT 5;



-- d. Find out the top 5 states where the order delivery is really fast as compared to the estimated date of delivery.
-- You can use the difference between the averages of actual & estimated delivery date to figure out how fast the delivery was for each state.

SELECT 
  CU.customer_state,
  SUM(DATE_DIFF(EXTRACT(DATE FROM O.order_delivered_customer_date),
            EXTRACT(DATE FROM O.ORDER_ESTIMATED_DELIVERY_DATE), DAY
          ))
FROM `SQL_TARGET.customers` AS CU    
JOIN `SQL_TARGET.orders` AS O  
ON O.CUSTOMER_ID = CU.customer_id
GROUP BY 1
ORDER BY 2
LIMIT 5;



-- 6. Analysis based on the payments:

-- a. Find the month on month no. of orders placed using different payment types.

SELECT 
  PY.PAYMENT_TYPE AS PAYMENT_METHOD,
  EXTRACT(YEAR FROM O.ORDER_PURCHASE_TIMESTAMP) AS YEAR,
  EXTRACT(MONTH FROM O.ORDER_PURCHASE_TIMESTAMP) AS MONTH,  
  COUNT(DISTINCT O.ORDER_ID) AS NO_OF_ORDERS
FROM `SQL_TARGET.payments` AS PY
JOIN `SQL_TARGET.orders` AS O  
ON O.order_id = PY.order_id
GROUP BY 1,2,3
ORDER BY 1,2,3;


-- b. Find the no. of orders placed on the basis of the payment installments that have been paid.

SELECT 
  payment_installments,
  COUNT(DISTINCT ORDER_ID) AS NO_OF_ORDERS
FROM `SQL_TARGET.payments`
GROUP BY 1;

