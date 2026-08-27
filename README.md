# Target E-Commerce Data Analysis -- SQL Project

## 📌 Project Overview

This project analyzes **Target's e-commerce operations in Brazil** using
SQL.

The objective is to explore customer orders, sales, freight costs,
delivery performance, customer distribution, and payment behavior. The
analysis is based on the provided Brazilian e-commerce dataset and the
six-question business problem statement.

The project demonstrates how SQL can be used to transform raw
transactional data into meaningful business insights that can support
decision-making.

------------------------------------------------------------------------

## 🎯 Business Problem

Assuming the role of a **Data Analyst / Data Scientist at Target**, the
goal is to analyze the available e-commerce data and answer important
business questions related to:

-   Customer and order characteristics
-   Order growth and seasonality
-   State-wise customer and order distribution
-   Order prices and freight costs
-   Delivery time and delivery performance
-   Payment methods and installments

The complete business requirements are provided in the **Target -
Problem Statement.pdf** file.

------------------------------------------------------------------------

## 📂 Project Structure

``` text
Target-Ecommerce-SQL-Analysis/
│
├── data/
│   ├── customers.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── order_payments.csv
│   ├── products.csv
│   ├── sellers.csv
│   ├── order_reviews.csv
│   └── geolocation.csv
│
├── Target SQL Queries.sql
├── Target - Problem Statement.pdf
└── README.md
```

> **Note:** Keep the dataset filenames/folder structure in this README
> synchronized with the files actually uploaded to this repository.

------------------------------------------------------------------------

## 🗃️ Dataset

The project uses a Brazilian e-commerce dataset containing information
about customers, orders, products, sellers, payments, reviews, and
geographical locations.

Important tables used in the analysis include:

  -----------------------------------------------------------------------
  Table                               Purpose
  ----------------------------------- -----------------------------------
  `customers`                         Customer location and customer
                                      information

  `orders`                            Order dates, delivery dates, and
                                      order status

  `order_items`                       Products, prices, freight values,
                                      and sellers associated with orders

  `order_payments` / `payments`       Payment type, payment value, and
                                      installments

  `products`                          Product information

  `sellers`                           Seller information

  `geolocation`                       Brazilian geographical information

  `order_reviews`                     Customer review information
  -----------------------------------------------------------------------

The exact table names may depend on how the CSV files were imported into
the SQL database.

------------------------------------------------------------------------

# 🔎 Analysis Performed

The business problem contains **6 major sections** with multiple
questions.

## 1. Data Exploration

The first section focuses on understanding the structure and
characteristics of the data.

### Questions answered

1.  What are the data types of all columns in the `customers` table?
2.  What is the time range during which orders were placed?
3.  How many cities and states have customers who ordered during the
    given period?

### Purpose

This helps establish the basic structure of the dataset and understand
the geographical and time coverage of the business.

------------------------------------------------------------------------

## 2. In-Depth Exploration

This section analyzes order trends and customer ordering behavior.

### Questions answered

1.  Is there a growing trend in the number of orders placed over the
    years?
2.  Is there monthly seasonality in the number of orders?
3.  During which time of the day do Brazilian customers mostly place
    orders?

The time categories are:

  Time             Category
  ---------------- -----------
  00:00 -- 06:00   Dawn
  07:00 -- 12:00   Morning
  13:00 -- 18:00   Afternoon
  19:00 -- 23:00   Night

### Purpose

The analysis helps identify growth patterns, seasonal demand, and
customer ordering behavior.

------------------------------------------------------------------------

## 3. Evolution of E-Commerce Orders in Brazil

This section focuses on geographical order patterns.

### Questions answered

1.  What is the month-on-month number of orders placed in each state?
2.  How are customers distributed across all Brazilian states?

### Purpose

This analysis helps Target understand:

-   Which states generate more orders
-   How customers are geographically distributed
-   How demand changes over time in different states

------------------------------------------------------------------------

## 4. Impact on Economy

This section analyzes the movement of money through e-commerce
transactions.

### Questions answered

1.  What was the percentage increase in the cost of orders from 2017 to
    2018, considering January to August?
2.  What are the total and average order values for each state?
3.  What are the total and average freight values for each state?

### Purpose

The analysis helps understand:

-   Sales/value growth
-   State-wise revenue contribution
-   Freight cost patterns
-   Average order economics

------------------------------------------------------------------------

## 5. Sales, Freight and Delivery Time Analysis

This section evaluates logistics and delivery performance.

### Questions answered

1.  How many days did each order take to be delivered?
2.  What is the difference between the actual and estimated delivery
    dates?
3.  Which 5 states have the highest and lowest average freight value?
4.  Which 5 states have the highest and lowest average delivery time?
5.  Which 5 states deliver orders fastest compared with the estimated
    delivery date?

### Delivery Metrics

The following calculations are used:

``` text
time_to_deliver =
order_delivered_customer_date - order_purchase_timestamp
```

``` text
diff_estimated_delivery =
order_delivered_customer_date - order_estimated_delivery_date
```

### Purpose

This analysis helps identify:

-   States with high logistics costs
-   States with slow delivery
-   States with strong delivery performance
-   Differences between promised and actual delivery

------------------------------------------------------------------------

## 6. Payment Analysis

The final section analyzes customer payment behavior.

### Questions answered

1.  What is the month-on-month number of orders placed using different
    payment types?
2.  How many orders were placed based on the number of payment
    installments?

### Purpose

This helps understand:

-   Customer payment preferences
-   Monthly payment-method trends
-   Popular installment options
-   Potential opportunities for payment strategy optimization

------------------------------------------------------------------------

# 🛠️ Technologies Used

-   **SQL**
-   **MySQL / MySQL Workbench**
-   **CSV**
-   **Git & GitHub**

------------------------------------------------------------------------

# 🧠 SQL Concepts Used

The project applies several important SQL concepts, including:

-   `SELECT`
-   `WHERE`
-   `GROUP BY`
-   `ORDER BY`
-   `HAVING`
-   `JOIN`
-   `LEFT JOIN`
-   Aggregate functions
    -   `COUNT()`
    -   `SUM()`
    -   `AVG()`
    -   `MIN()`
    -   `MAX()`
-   Date and time functions
-   String/date extraction
-   Conditional logic using `CASE`
-   Subqueries
-   Common analytical calculations
-   Ranking and top/bottom analysis
-   Month-on-month analysis

------------------------------------------------------------------------

# 🔄 General Analysis Workflow

``` text
Raw CSV Data
     ↓
Import into SQL Database
     ↓
Understand Tables & Columns
     ↓
Data Exploration
     ↓
Data Cleaning / Preparation
     ↓
JOIN Related Tables
     ↓
Perform SQL Analysis
     ↓
Calculate Business Metrics
     ↓
Generate Business Insights
     ↓
Provide Recommendations
```

------------------------------------------------------------------------

# 💡 Key Business Insights

The SQL analysis is designed to help Target answer questions such as:

-   Is e-commerce demand increasing over time?
-   Which months have higher order volumes?
-   When do customers usually place orders?
-   Which states have the largest customer base?
-   Which states generate higher order values?
-   Where are freight costs high?
-   Which states have faster or slower deliveries?
-   Are orders generally delivered before or after the estimated date?
-   Which payment methods are most popular?
-   How frequently do customers use installments?

The actual numerical findings should be taken directly from the results
of the SQL queries in this project.

------------------------------------------------------------------------

# 📊 Business Recommendations

Based on the analysis, Target can potentially:

1.  **Improve inventory planning** in states and months with high order
    demand.
2.  **Optimize logistics** in states with high freight costs.
3.  **Improve delivery operations** in states with longer delivery
    times.
4.  **Use seasonal demand patterns** for marketing and inventory
    planning.
5.  **Optimize payment options** based on customer payment preferences.
6.  **Monitor estimated vs. actual delivery performance** to improve
    customer satisfaction.
7.  **Prioritize high-value markets** for business expansion and
    targeted campaigns.

> Recommendations should be refined using the actual numerical results
> obtained from the SQL analysis.

------------------------------------------------------------------------

# 📁 Files in This Project

### `Target - Problem Statement.pdf`

Contains the complete business problem and the six sections of questions
provided for the analysis.

### SQL Query File

Contains the SQL queries written to answer all the questions in the
business problem.

### CSV Dataset Files

Contain the raw e-commerce data used for the analysis.

### `README.md`

Provides an overview of the project, business problem, analysis
performed, technologies used, and business objectives.

------------------------------------------------------------------------

# 🚀 How to Use This Project

## 1. Download / Clone the Repository

``` bash
git clone <repository-url>
```

## 2. Import the CSV Files

Import the provided CSV files into your SQL database.

## 3. Create / Select the Database

Open your SQL environment such as **MySQL Workbench** and select the
database containing the imported tables.

## 4. Run the SQL Queries

Open the project's SQL query file and execute the queries section by
section.

## 5. Analyze the Results

Review the query outputs to identify trends and business insights.

------------------------------------------------------------------------

# 📌 Project Objective in One Sentence

> **Analyze Target's Brazilian e-commerce data using SQL to understand
> customer behavior, order trends, sales, freight costs, delivery
> performance, and payment patterns, and convert the analysis into
> useful business insights.**

------------------------------------------------------------------------

# 👨‍💻 Author

**Nethikar Sharath**

MCA \| Data Science Enthusiast

------------------------------------------------------------------------

## ⭐ Project Status

**Completed --- SQL Business Analysis Project**

If you find this project useful, feel free to ⭐ the repository.
