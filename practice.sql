CREATE DATABASE Practice

use practice

create table customers(
cus_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
first_name  VARCHAR(40),
last_name  VARCHAR(40),
email VARCHAR(40),
phone_no INT(16)
);

DESCRIBE customers;

select * from customers

CREATE TABLE orders (
  `order_id` INT PRIMARY KEY NOT NULL  AUTO_INCREMENT,
  `order_date` date,
  `cus_id_fk` INT,
--contraint is used to apply rules to a,table. it ensures accuracy of the data in the tables--
CONSTRAINT customer_check FOREIGN KEY (cus_id_fk) REFERENCES customers(cus_id)
);

insert into orders( cus_id_fk, order_date) VALUES(
1, CURDATE()
)


DESCRIBE orders

select * from orders

select * FROM customers

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