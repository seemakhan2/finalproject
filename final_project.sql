-- Coffee Shop Database Final Project
-- Seema Khan

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE menu_items (
    menu_item_id SERIAL PRIMARY KEY,
    category_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(6,2) NOT NULL CHECK (price >= 0),
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(30) NOT NULL DEFAULT 'Completed',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    item_price NUMERIC(6,2) NOT NULL CHECK (item_price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_item_id)
);

-- Index chosen on purpose:
-- This helps speed up searches for orders by customer.
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

INSERT INTO customers (first_name, last_name, email, phone) VALUES
('Ava', 'Martinez', 'ava.martinez@email.com', '845-555-1001'),
('Liam', 'Johnson', 'liam.johnson@email.com', '845-555-1002'),
('Sophia', 'Lee', 'sophia.lee@email.com', '845-555-1003'),
('Noah', 'Brown', 'noah.brown@email.com', '845-555-1004'),
('Mia', 'Davis', 'mia.davis@email.com', '845-555-1005');

INSERT INTO employees (first_name, last_name, role) VALUES
('Emma', 'Wilson', 'Cashier'),
('James', 'Taylor', 'Barista'),
('Olivia', 'Anderson', 'Shift Manager');

INSERT INTO categories (category_name) VALUES
('Coffee'),
('Tea'),
('Pastries'),
('Sandwiches');

INSERT INTO menu_items (category_id, item_name, description, price, is_available) VALUES
(1, 'Iced Latte', 'Espresso with milk over ice', 4.75, TRUE),
(1, 'Cappuccino', 'Espresso with steamed milk and foam', 4.25, TRUE),
(1, 'Cold Brew', 'Slow brewed iced coffee', 4.50, TRUE),
(2, 'Chai Tea', 'Spiced black tea with milk', 4.00, TRUE),
(2, 'Green Tea', 'Hot green tea', 3.25, TRUE),
(3, 'Blueberry Muffin', 'Fresh baked muffin', 3.50, TRUE),
(3, 'Croissant', 'Buttery flaky pastry', 3.75, TRUE),
(4, 'Turkey Sandwich', 'Turkey sandwich with lettuce and tomato', 8.50, TRUE),
(4, 'Veggie Wrap', 'Vegetable wrap with hummus', 7.75, TRUE);

INSERT INTO orders (customer_id, employee_id, order_date, order_status) VALUES
(1, 1, '2026-04-20 09:15:00', 'Completed'),
(2, 2, '2026-04-20 10:05:00', 'Completed'),
(3, 1, '2026-04-21 12:30:00', 'Completed'),
(4, 3, '2026-04-21 14:10:00', 'Completed'),
(5, 2, '2026-04-22 08:45:00', 'Completed'),
(1, 3, '2026-04-22 11:20:00', 'Completed');

INSERT INTO order_items (order_id, menu_item_id, quantity, item_price) VALUES
(1, 1, 1, 4.75),
(1, 6, 1, 3.50),
(2, 2, 2, 4.25),
(3, 8, 1, 8.50),
(3, 5, 1, 3.25),
(4, 3, 1, 4.50),
(4, 7, 2, 3.75),
(5, 4, 1, 4.00),
(5, 9, 1, 7.75),
(6, 1, 2, 4.75),
(6, 6, 1, 3.50);

-- Query 1: Menu items under $5
SELECT item_name, price
FROM menu_items
WHERE price < 5.00
ORDER BY price ASC;

-- Query 2: Show each order with customer and employee
SELECT 
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    e.first_name || ' ' || e.last_name AS employee_name,
    o.order_date,
    o.order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN employees e ON o.employee_id = e.employee_id
ORDER BY o.order_date;

-- Query 3: Show items in each order
SELECT 
    o.order_id,
    mi.item_name,
    oi.quantity,
    oi.item_price,
    (oi.quantity * oi.item_price) AS line_total
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN menu_items mi ON oi.menu_item_id = mi.menu_item_id
ORDER BY o.order_id;

-- Query 4: Category summary
SELECT 
    c.category_name,
    COUNT(mi.menu_item_id) AS number_of_items,
    ROUND(AVG(mi.price), 2) AS average_price
FROM categories c
JOIN menu_items mi ON c.category_id = mi.category_id
GROUP BY c.category_name
ORDER BY c.category_name;

-- Query 5: Items above average price
SELECT item_name, price
FROM menu_items
WHERE price > (
    SELECT AVG(price)
    FROM menu_items
)
ORDER BY price DESC;

-- Query 6: Total spent by each customer
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(oi.quantity * oi.item_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;
