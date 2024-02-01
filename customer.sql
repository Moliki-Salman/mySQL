use user_database

drop  table customer

CREATE TABLE `customer` (
  `customer_id` int PRIMARY key AUTO_INCREMENT,
  `cus_FullName` VARCHAR(225),
  `cus_contact`  VARCHAR(225),
  `email`  VARCHAR(225),
  `cusdate` date
);
CREATE TABLE `Bill` (
  `bill_id`  int PRIMARY key AUTO_INCREMENT,
  `amount` DECIMAL,
  `billcode` VARCHAR(255) UNIQUE,
  `bill_date` DATE ,
  `Customer_id_fk`int,
  constraint customer_bill FOREIGN KEY (Customer_id_fk) REFERENCES customer(customer_id)@@
);

CREATE TABLE `Payment` (
  `payment_id` int PRIMARY key AUTO_INCREMENT,
  `payment_date` date,
  `amount_paid` DECIMAL,
  `payment_mode` VARCHAR(255),
  `customer_id_fk` int,
  --constraint is like a check that will help you check
constraint customer_payment FOREIGN KEY (customer_id_fk) REFERENCES customer(customer_id)
);

show TABLES

--this inserts the values into the customer table.
INSERT into customer (`cus_FullName`,`cus_contact`,cusdate,email)VALUES
('john', '4556778',curdate(),'john@gmail.com');

INSERT INTO Bill (`billcode`, amount, `bill_date`, `customer_id_fk`)VALUES
('bill007', 3000, '2024-01-15', 5)

--this displays all the entire customer table
SELECT * from customer;

SELECT * from Bill;

-- this displaces all columns on both customer table and bill table.
SELECT * from customer INNER JOIN Bill on customer.`customer_id` = Bill.`Customer_id_fk`

SELECT  customer_id,customer.cus_fullname,Bill.amount,customer.cusdate,Bill.billcode from customer
inner JOIN `Bill` on customer.`customer_id` = Bill.`Customer_id_fk`;

SELECT cus_fullname, amount from customer  left OUTER join `Bill` on customer.`customer_id` = Bill.`Customer_id_fk`;

TRUNCATE Bill;


INSERT into `Payment` (`amount_paid`,`payment_mode`,`payment_date`,`customer_id_fk`)VALUES (400,'cash',CURDATE(),2);

SELECT * from `Payment`;

SELECT * from `Bill`;

update  `Payment` set customer_id_fk = 1;


--sum is a function
SELECT sum(amount_paid) from `Payment` where  customer_id_fk = 1;


SELECT sum(amount) from `Bill` WHERE `Customer_id_fk` = 1;


SELECT customer.`cus_FullName`,amount_paid ,Bill.amount from customer
left outer JOIN
`Payment` on customer.`customer_id`
= Payment.`customer_id_fk` left outer JOIN `Bill` on customer.`customer_id` = Bill.`Customer_id_fk`
WHERE `customer_id` = 1

--creating a table to store balance for each the transactions
CREATE table trans(
trans_id int  PRIMARY  KEY AUTO_INCREMENT,
total_bill  DECIMAL,
total_amount_paid  DECIMAL,
outstanding DECIMAL,
customer_id int,
trans_date  DATETIME DEFAULT CURRENT_TIMESTAMP
);


--to build a named query/view
--
CREATE view total_payment as
select sum(amount_paid) as total_amount, `customer_id_fk` from
`Payment` GROUP BY `customer_id_fk`

SELECT * from `total_payment`;

--this means,select all the  records of the total amount, and name it as total bill
--with the customer id from bill table and GROUP BY i.e group this records and display based on their customer_id_fk
create view total_bills as
SELECT sum(amount) as total_bills, customer_id_fk  from `Bill` GROUP BY `Customer_id_fk`;

SELECT * from `total_bills`;

drop VIEW total_bills;
drop view `total_payment`;

/*take the customer_id_fk of total_bill view and total_amount of the total_payment view,
and the total_bills under total_bills's view column,
then subtract (`total_bills` column - `total_amount` column),name the result outstanding,
then  do the inner join from `total_payments` and `total_bills`,
where `total_bills`.`customer_id_fk` = 2,  and total_payments.`customer_id_fk` = 2.
HOW EVER THIS ONLY GIVES US THE CURRENT BALANCE,WE CANNOT READ THE BALANCE PERIODICALLY AS IT CHANGES.
*/
SELECT `total_bills`.`customer_id_fk`, `total_payments`.`total_amount`,`total_bills`,
 (`total_bills` - `total_amount`) as outstanding
  from
   `total_payments` INNER JOIN `total_bills`
where `total_bills`.`customer_id_fk` = 2
 and total_payments.`customer_id_fk` = 2

SELECT * from trans

/*
-keep log of balance per transaction;
-store every transaction in the trasaction table;
-make use of stored procedure in this process;
-consider stored procedure like functions in javascript POV;
-allows you to write logic such as declaring variablesand implementing;
-conditional statament

-AlGORITHM or approach to acquire balnace per transactions.
1) use the customer_id in all operations to achieve the best result;
2) create a PROCEDURE to pass customer_id and amount
3) create a variable to store total bills
4) create a variable to store total amount plus the new amount
5) calculate outstanding
6) save data in the TRANSACTION  table;

 --what is a stored procedure, a stored precedure is like alogic for processing data storage.
NOTE YOU CANNOT CREATE A  STORED PROCEDURE HERE IN THE STATEMENT,
ITS NOT ALLOWED,WE NEED TO CREATE A NEW FILE, SO CHECK THE NAV BAR , YOU WILL SEE PROCEDURE, CREATE IT FROM THERE
*/

--call procedure
call `proc_name`()