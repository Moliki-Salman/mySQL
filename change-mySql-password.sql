-- first, you need to start a new query for you to work wit;
--then run this code below to display all the inbuilt usersof mysql

SELECT User , Host FROM mysql.user;

--  this code helps to change the password of mysql database.Note the 1234 here stands for the new password to change to.
ALTER USER 'root'@'localhost' IDENTIFIED BY '1234';