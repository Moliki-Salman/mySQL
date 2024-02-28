CREATE DATABASE Practice

use practice

create table customers(
cus_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
first_name  VARCHAR(40),
last_name  VARCHAR(40),
email VARCHAR(40),
phone_no INT (16)
);


DESCRIBE customers;

select * from customers

--this disolays the first 4 rolls on the customers table.
select* from customers  limit 4 OFFSET 3

--this is used to delete columns from a table using the column name.
delete from customers where first_name = ''


CREATE TABLE orders (
  `order_id` INT PRIMARY KEY NOT NULL  AUTO_INCREMENT,
  `order_date` date,
  `cus_id_fk` INT,
--contraint is used to apply rules to a,table. it ensures accuracy of the data in the tables--
CONSTRAINT customer_check FOREIGN KEY (cus_id_fk) REFERENCES customers(cus_id)
);

--to changethe columnsin a tabke
alter table orders modify column order_id int  AUTO_INCREMENT

insert into orders( cus_id_fk, order_date) VALUES(
1, CURDATE()
)


DESCRIBE orders

select * from orders

select * FROM customers

delete from customers

INSERT INTO customers(first_name, last_name, email, phone_no)
VALUES ('Tbi00', 'Bamidele', 'bams@gmail.com', '+2349087'),
('Oluwatosin', 'Bayode', 'tosin@gmail.com', '+2349077'),
('Oluchi', 'Joseph', 'oluchi@gmail.com', '+23490976')


CREATE TABLE `categories` (
  `category_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `category_name`VARCHAR(250)
);

INSERT INTO  `categories`(category_name) VALUES(
'office appliances'
);

DESCRIBE categories

SELECT * FROM  categories

CREATE TABLE `products` (
  `product_id` int PRIMARY KEY  NOT NULL AUTO_INCREMENT,
  `product_Name` VARCHAR(250),
  `category_id_fk` INT,
  `prices` DECIMAL,
  `stockQuantity`DECIMAL,
-- CHECK is used to ensures that the values in a column satisfies a specific condition
CONSTRAINT stock_check CHECK (`stockQuantity` >= 0)
)

insert into products (product_Name, category_id_fk, prices, stockQuantity)
values('Refridgirator', 1, 4000, 2
)

CREATE TABLE `orderDetails` (
  `orderDetails_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `order_id_fk` INT,
  `product_id_fk` INT,
  `quantity` INT,
  `totalPrice` DECIMAL,
-- it is important to refrences the name of the table b4 stating the column eg products(product_id)
  CONSTRAINT available_prod FOREIGN KEY (product_id_fk) REFERENCES products(product_id)
);

SELECT * FROM products


SELECT * FROM orderDetails

insert into orderDetails(order_id_fk, product_id_fk, quantity,  totalPrice)
values( 1, 2, 4, 12000
)

SELECT * FROM customers INNER JOIN orders on customers.cus_id = orders.cus_id_fk


/*Create a view that displays the details of a customer's order, including customer
information, order date, product details, quantity, and total price*/

create view cus_order_details AS
SELECT customers.*, orders.*, products.product_Name, products.prices, orderDetails.quantity, orderDetails.totalPrice
from customers INNER JOIN orders on customers.cus_id = orders.cus_id_fk
INNER JOIN orderDetails on orders.order_id = orderDetails.order_id_fk
INNER JOIN products on products.`product_id` = orderDetails.`product_id_fk` WHERE cus_id = 1;


SELECT customers.*, orders.*, products.product_Name, products.prices, orderDetails.quantity, orderDetails.totalPrice
from customers INNER JOIN orders on customers.cus_id = orders.cus_id_fk
INNER JOIN orderDetails on orders.order_id = orderDetails.order_id_fk
INNER JOIN products on products.`product_id` = orderDetails.`product_id_fk` WHERE cus_id = 1;

-- create a procedure to calculate the total revenue generated for a specific product (quantity sold and product price)
--to know the total quantity sold
create view total_qauntity_sold AS
SELECT product_Name, sum(quantity) as quantity_sold from orderDetails INNER JOIN products
on orderDetails.product_id_fk = products.product_id GROUP BY product_id_fk

select * from total_qauntity_sold

create table revenue (
revenue_id int primary key AUTO_INCREMENT,
product_Name VARCHAR(300),
product_Price DECIMAL,
total_qauntity_sold DECIMAL,
total_revenue DECIMAL,
revenue_date DATETIME DEFAULT CURRENT_TIMESTAMP
)

alter table revenue  CHANGE product_Name product_id int

DESCRIBE revenue
--sum up the quantity of a product and assign it to to the quantity-sold VARIABLES
--get the price from product table for a given product and assign it to the product-price variable

-- assign the result of quantity-sold * product-price to the total-amount variable
-- insert the results to the revenue table

-- display the content of the revenue table.


-- create total_revenue procedure that take in 3 parameter (quantity sold, product price and product id)
-- to calculate the total revenue

CREATE PROCEDURE total_revenue (in prod_price DECIMAL, in qtn_sold DECIMAL, in prod_id INT)
BEGIN
DECLARE product_price DECIMAL;
DECLARE quantity_sold DECIMAL;
DECLARE total_amount DECIMAL;

select sum(quantity) into quantity_sold from orderDetails WHERE orderDetails.product_id_fk = prod_id;

select prices into product_price from products WHERE products.product_id = prod_price;

set total_amount = quantity_sold * product_price;

INSERT INTO revenue(product_id, product_Price, total_qauntity_sold, total_revenue  ) VALUES(
prod_id, product_price, quantity_sold, total_amount
);

SELECT * FROM revenue;
END;

call total_revenue(1, 400, 2);

SELECT * FROM revenue;

