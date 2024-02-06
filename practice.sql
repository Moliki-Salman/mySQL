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

CREATE TABLE orders (
  `order_id` INT PRIMARY KEY NOT NULL  AUTO_INCREMENT,
  `order_date` date,
  `cus_id_fk` INT,
CONSTRAINT customer_check FOREIGN KEY (cus_id_fk) REFERENCES customers(cus_id)
);