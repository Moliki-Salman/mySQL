-- Active: 1704883746215@@127.0.0.1@3306@techHaven
use techHaven

-- create the customer table
CREATE TABLE `customers` (
  `cus_id` INT PRIMARY KEY AUTO_INCREMENT,
  `first_name` VARCHAR(25),
  `last_name` VARCHAR(25),
  `email` VARCHAR(50) UNIQUE,
  `phone_no` VARCHAR(15)
);

-- create the orders table
CREATE TABLE `orders` (
  `order_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `order_date` date,
  `cus_id_fk` INT,
  CONSTRAINT customer_check FOREIGN KEY (cus_id_fk) REFERENCES customers(cus_id)
);

-- create the order_details table.
CREATE TABLE `orders_details` (
  `oder_details_id` INT PRIMARY KEY AUTO_INCREMENT,
  `total_price` DECIMAL,
  `order_id_fk` int,
  `prod_id_fk` int,
  CONSTRAINT available_prod FOREIGN KEY (prod_id_fk) REFERENCES products(prod_id)
);

-- added an addditional column named quantityto the oder_details table.
alter table orders_details add COLUMN quantity DECIMAL;

-- create the products table
CREATE TABLE `products` (
  `prod_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `prod_name` VARCHAR(255),
  `category_id_fk` INT,
  `price` DECIMAL,
  `stock_quantity` DECIMAL,
  CONSTRAINT `stock_check` CHECK (`stock_quantity` >= 0)
);

-- create the categories table
CREATE TABLE `categories` (
  `catergory_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(255)
);

-- insert records into the customer table.
INSERT INTO customers(first_name, last_name, email, phone_no)
VALUES ('Damilola', 'Moliki-Salman', 'damilola@gmail.com', '+2349087678'),
('Oluwatosin', 'Bayode', 'tosin@gmail.com', '+2349077875'),
('Oluchi', 'Joseph', 'oluchi@gmail.com', '+23490976437')


-- insert record into the orders table.
INSERT INTO orders(order_date, cus_id_fk)
VALUES (CURDATE(), 3);

--deleted a record from the orders table
DELETE from orders WHERE order_id = 5;

--insert record into the orders_details table.
insert INTO orders_details(total_price, order_id_fk, prod_id_fk, quantity)
VALUES (35000, 3, 2, 1);

--insert record into the categories table.
INSERT INTO categories (category_name ) VALUES(
     'OFFICE APPLIANCES'
);

--insert record into the products table.
INSERT INTO  products ( prod_name, category_id_fk, price, stock_quantity )
VALUES( 'hP Pavillion', 2, 1000000, 5);

-- DISPLAY TABLES CONTENT
select * FROM customers;
SELECT * FROM orders;

SELECT * FROM orders_details;

SELECT * FROM categories;

SELECT * FROM products;

SELECT * FROM orders_details;

SELECT * FROM cus_order_details;


/* displays the details of a customer's order, including customer
information, order date, product details, quantity, and total price.*/
SELECT customers.*, orders.`order_id`, orders.`order_date`,
`category_id_fk`, products.`prod_name`, products.`price`, orders_details.`quantity`, orders_details.`total_price`
from customers INNER JOIN orders on customers.cus_id = orders.cus_id_fk
INNER JOIN orders_details on orders.`order_id` = orders_details.`order_id_fk`
INNER JOIN products on products.`prod_id` = orders_details.`prod_id_fk` WHERE cus_id = 2;

/* Create a view that displays the details of a customer's order, including customer
information, order date, product details, quantity, and total price.*/
CREATE VIEW cus_order_details AS
SELECT `first_name`, `last_name`, `email`, `phone_no`, orders.`order_id`, orders.`order_date`,
`category_id_fk`, products.`prod_name`, products.`price`, orders_details.`quantity`, orders_details.`total_price`
from customers INNER JOIN orders on customers.cus_id = orders.cus_id_fk
INNER JOIN orders_details on orders.`order_id` = orders_details.`order_id_fk`
INNER JOIN products on products.`prod_id` = orders_details.`prod_id_fk` WHERE cus_id = 1;

/* create a view called total_bills that displays the sum of total amount of product bought by a customer
which is taken from the bill table*/
CREATE VIEW total_bills AS
SELECT sum(amount) as total_bills, customer_id_fk FROM Bill GROUP BY `Customer_id_fk`;

/* create a view called total_quantity.This view includes the sum total of all the quantity of a customers'order
(taken from the orders_details table) and prod_name. the view also includes the products id which must be the as
the products id foreign key inside the orders_details table.*/
create VIEW total_quantity AS
select prod_name, sum(quantity) as quantity_sold from orders_details INNER JOIN products on orders_details.prod_id_fk = products.prod_id GROUP BY `prod_id_fk`;


-- display the content of the total_quantity
SELECT * FROM total_quantity;

-- create a table to insert the prod_name, price, total quantity sold and total revenue.
CREATE TABLE revenue(
    revenue_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255),
    product_price DECIMAL,
    total_qty_sold DECIMAL,
    total_rev DECIMAL,
    revenue_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- change the product_name column to product_id
alter Table revenue CHANGE product_name product_id INT;

/*
    create total_revenue procedure that take in 3 parameter (quantity order, product price and product id)
    to calculate the total revenue
*/
CREATE PROCEDURE total_revenue(in qty_sold DECIMAL, in single_price DECIMAL, in pro_id INT)
BEGIN
    -- declare 3 variables to hold the product price, quantity sold and total amount
    DECLARE prod_price DECIMAL;
    DECLARE quantity_sold DECIMAL;
    DECLARE total_amount DECIMAL;

    -- sum up the quantity ordered for  a given product and assign it to the quantity_sold variable
    select sum(quantity) into quantity_sold from orders_details
    WHERE orders_details.`prod_id_fk` = pro_id;

    -- Get the price from products table for a given product and assign it to the prod_price variable
    select price into prod_price from products
    WHERE products.`prod_id` = pro_id;

    -- assign the result of quantity_sold * prod_price to the total_amount variable
    set total_amount = quantity_sold * prod_price;

    -- insert the results to the revenue table
    INSERT INTO  revenue ( product_id, product_price, total_qty_sold, total_rev ) VALUES(
        pro_id, prod_price, quantity_sold, total_amount);

-- display the content of the revenue table.
SELECT * FROM revenue;
END;

-- Call the total_revenue procedure and pass the three arguments
call total_revenue(2, 400, 1);

-- view the records of the revenue
SELECT * FROM revenue;