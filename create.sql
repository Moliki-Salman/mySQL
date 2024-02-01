use user_database;

SHOW  TABLES;

DESCRIBE  user_table;

INSERT INTO  user_table(user_id,username,fullname,contact,email)
values(4, "@hjik", "sidiq", "23456", "amoerfidi@gmail"),
(2, "@spiujnuhn", "sidiq", "23456", "auyhidi@gmail"),
(3, "@spiiuhk", "sidiq", "23456", "aomnosidi@gmail");

-- * is used to select all the columns in a table --
select * from user_table;

-- describe showa all the table format
DESCRIBE user_table;


-- AUTO_INCREMENT automatically
create Table user_table_auto(
userid int PRIMARY KEY not NULL AUTO_INCREMENT,
username VARCHAR(39) UNIQUE
)

--this changes the userid to user_id
alter Table  user_table_auto CHANGE userid user_id int not NULL AUTO_INCREMENT

DESCRIBE  user_table_auto

INSERT INTO  user_table_auto(username)
values("@spyujj")

--this is used to retreive your record
select * from  user_table_auto

--delete will delete the content in the table but will leave the table;
-- the auto increament does not start from the beginning when you create another ecord inthe table
delete from user_table_auto

--'' delete the content in the table but will leave the table;
-- the auto increament does not start from the beginning when you create another ecord inthe table
TRUNCATE  user_table_auto


