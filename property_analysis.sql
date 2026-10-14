
-- PROJECT: Property Listings Analysis
-- Database: MySQL
-- Objective: Analyze property prices, agent performance,
-- and monthly property sales.

CREATE DATABASE IF NOT EXISTS property_analysis;
USE property_analysis;

-- 1. Create Agents table
CREATE TABLE IF NOT EXISTS agents (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    experience_years INT
);

-- 2. Create Properties table
CREATE TABLE IF NOT EXISTS properties (
    property_id INT PRIMARY KEY,
    property_type VARCHAR(50),
    city VARCHAR(50),
    listing_price DECIMAL(12,2),
    agent_id INT,
    FOREIGN KEY (agent_id)
        REFERENCES agents(agent_id)
);

-- 3. Create Sales table
CREATE TABLE IF NOT EXISTS sales (
    sale_id INT PRIMARY KEY,
    property_id INT,
    sale_price DECIMAL(12,2),
    sale_date DATE,
    FOREIGN KEY (property_id)
        REFERENCES properties(property_id)
);

-- 4. Insert sample agents
INSERT INTO agents VALUES
(1, 'Ravi Kumar', 'Hyderabad', 5),
(2, 'Priya Sharma', 'Vizag', 3),
(3, 'Arjun Reddy', 'Hyderabad', 7),
(4, 'Sneha Rao', 'Vijayawada', 4),
(5, 'Kiran Kumar', 'Vizag', 6);

-- 5. Insert sample properties
INSERT INTO properties VALUES
(201, 'Apartment', 'Hyderabad', 6500000, 1),
(202, 'Villa', 'Hyderabad', 12000000, 3),
(203, 'Apartment', 'Vizag', 4500000, 2),
(204, 'Plot', 'Vijayawada', 2500000, 4),
(205, 'Villa', 'Vizag', 9000000, 5),
(206, 'Apartment', 'Hyderabad', 5500000, 3),
(207, 'Plot', 'Hyderabad', 3500000, 1),
(208, 'Apartment', 'Vijayawada', 4000000, 4),
(209, 'Villa', 'Hyderabad', 15000000, 3),
(210, 'Plot', 'Vizag', 3000000, 2);

-- 6. Insert sample sales
INSERT INTO sales VALUES
(301, 201, 6400000, '2026-01-15'),
(302, 203, 4400000, '2026-01-22'),
(303, 202, 11800000, '2026-02-10'),
(304, 204, 2450000, '2026-02-18'),
(305, 206, 5400000, '2026-03-05'),
(306, 205, 8800000, '2026-03-20'),
(307, 207, 3400000, '2026-04-12'),
(308, 208, 3900000, '2026-04-25'),
(309, 209, 14800000, '2026-05-08'),
(310, 210, 2900000, '2026-05-19');

-- 7. Display all properties
SELECT *
FROM properties;

-- 8. Find Hyderabad properties
SELECT property_id, property_type, city, listing_price
FROM properties
WHERE city = 'Hyderabad'
ORDER BY listing_price DESC;

-- 9. Average property price by city
SELECT
    city,
    COUNT(*) AS total_properties,
    ROUND(AVG(listing_price), 2) AS average_price
FROM properties
GROUP BY city
ORDER BY average_price DESC;

-- 10. Average price by property type
SELECT
    property_type,
    COUNT(*) AS property_count,
    ROUND(AVG(listing_price), 2) AS average_price
FROM properties
GROUP BY property_type
ORDER BY average_price DESC;

-- 11. Display properties with agent details
SELECT
    p.property_id,
    p.property_type,
    p.city,
    p.listing_price,
    a.agent_name,
    a.experience_years
FROM properties p
JOIN agents a
    ON p.agent_id = a.agent_id
ORDER BY p.listing_price DESC;

-- 12. Total sales value by city
SELECT
    p.city,
    COUNT(s.sale_id) AS properties_sold,
    SUM(s.sale_price) AS total_sales_value
FROM properties p
JOIN sales s
    ON p.property_id = s.property_id
GROUP BY p.city
ORDER BY total_sales_value DESC;

-- 13. Monthly sales analysis
SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS sales_month,
    COUNT(*) AS total_sales,
    SUM(sale_price) AS monthly_sales_value,
    ROUND(AVG(sale_price), 2) AS average_sale_price
FROM sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY sales_month;

-- 14. Top-performing agents by sales value
SELECT
    a.agent_name,
    COUNT(s.sale_id) AS properties_sold,
    SUM(s.sale_price) AS total_sales_value
FROM agents a
JOIN properties p
    ON a.agent_id = p.agent_id
JOIN sales s
    ON p.property_id = s.property_id
GROUP BY a.agent_id, a.agent_name
ORDER BY total_sales_value DESC;

-- 15. Properties priced above the average listing price
SELECT property_id, property_type, city, listing_price
FROM properties
WHERE listing_price > (
    SELECT AVG(listing_price)
    FROM properties
)
ORDER BY listing_price DESC;

-- 16. Compare listing price with actual sale price
SELECT
    p.property_id,
    p.property_type,
    p.city,
    p.listing_price,
    s.sale_price,
    p.listing_price - s.sale_price AS price_difference
FROM properties p
JOIN sales s
    ON p.property_id = s.property_id
WHERE s.sale_price < p.listing_price
ORDER BY price_difference DESC;

-- 17. Agents who sold more than one property
SELECT
    a.agent_name,
    COUNT(s.sale_id) AS properties_sold
FROM agents a
JOIN properties p
    ON a.agent_id = p.agent_id
JOIN sales s
    ON p.property_id = s.property_id
GROUP BY a.agent_id, a.agent_name
HAVING COUNT(s.sale_id) > 1
ORDER BY properties_sold DESC;

-- 18. Overall sales summary
SELECT
    COUNT(*) AS total_properties_sold,
    SUM(sale_price) AS total_sales_revenue,
    ROUND(AVG(sale_price), 2) AS average_sale_price,
    MIN(sale_price) AS lowest_sale_price,
    MAX(sale_price) AS highest_sale_price
FROM sales;
