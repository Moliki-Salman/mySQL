-- Active: 1704883746215@@127.0.0.1@3306@user_database
CREATE PROCEDURE `acceptPay`( in cus_id int, in amt DECIMAL)
BEGIN
DECLARE total_payments DECIMAL;
DECLARE total_bills  DECIMAL ;
DECLARE outstanding DECIMAL;
-- inert into `Payment` table
INSERT into `Payment` (`amount_paid`,`payment_mode`,`payment_date`,`customer_id_fk`)
VALUES (amt,'cash',CURDATE(),cus_id);
-- fetch all data for selected customer
select sum(amount_paid)  into total_payments  from
`Payment` WHERE `customer_id_fk` = cus_id;
SELECT sum(amt) into total_bills from
`Bill` WHERE Bill.`Customer_id_fk` = cus_id;
-- calculate outstanding for on customer id
set outstanding = total_bills - total_payments ;
INSERT into trans (`total_bill`,`total_amount_paid`,outstanding,`customer_id`)
VALUES(total_bills,total_payments,outstanding,cus_id);
SELECT * from trans;
END;