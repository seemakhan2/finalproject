# finalproject

# Coffee Shop Database Project

## Project Overview
This project is a PostgreSQL database system designed for a coffee shop. The database stores and manages information related to customers, employees, menu items, categories, orders, and order details. The purpose of the system is to help organize coffee shop operations and allow useful business queries to be performed on the data.


## Files Included

### project.sql
Contains:
- All `CREATE TABLE` statements
- Primary key and foreign key constraints
- Sample data inserts
- Index creation
- Required SQL queries

### README.md
Provides:
- Project overview
- File descriptions
- Instructions for running the project

### Final_Coffee_Shop_Database.pdf

 ## Database Tables

The database contains the following tables:

- `customers`
- `employees`
- `categories`
- `menu_items`
- `orders`
- `order_items`

  ## Features
- Tracks customer orders
- Stores employee order information
- Organizes menu items into categories
- Maintains historical pricing through the `order_items` table
- Supports useful business queries and reporting
  
  ## Query Types Included

The project includes the required SQL query types:

1. Basic filter/order query
2. Join query #1
3. Join query #2
4. Aggregation query with `GROUP BY`
5. Subquery
6. Additional useful query


## How to Run the SQL

1. Open PostgreSQL or pgAdmin.
2. Create a new database.
3. Open the `project.sql` file.
4. Run the SQL script.
5. The script will:
   - Create the tables
   - Add constraints
   - Insert sample data
   - Create indexes
   - Run the required queries

## Normalization
The database design is normalized to approximately Third Normal Form (3NF) to reduce redundancy and improve organization.

## AI Disclosure
ChatGPT was used to assist with:
- Generating sample data
- Revising sections of the schema summary
- Creating some SQL queries
- Improving wording and organization in the final write-up
