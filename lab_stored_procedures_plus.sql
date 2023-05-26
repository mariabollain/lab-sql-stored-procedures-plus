use sakila;

# 1. Write a query to find what is the total business done by each store.

SELECT S.store_id, SUM(P.amount) AS total_amount
FROM payment P
JOIN staff S USING (staff_id)
GROUP BY store_id;

# 2. Convert the previous query into a stored procedure.

DELIMITER //
CREATE PROCEDURE amount_store()
BEGIN 
SELECT S.store_id, SUM(P.amount) AS total_amount
FROM payment P
JOIN staff S USING (staff_id)
GROUP BY store_id;
END //
DELIMITER;

CALL amount_store;

# 3. Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DROP PROCEDURE IF EXISTS amount_store;

DELIMITER //
CREATE PROCEDURE amount_store(IN store int)
BEGIN 
SELECT S.store_id, SUM(P.amount) AS total_amount
FROM payment P
JOIN staff S USING (staff_id)
GROUP BY store_id
HAVING store_id = store;
END //
DELIMITER;

CALL amount_store(1);

# 4. Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 
# Call the stored procedure and print the results.

DROP PROCEDURE IF EXISTS amount_store;

DELIMITER //
CREATE PROCEDURE amount_store(IN store int, OUT sales float)
BEGIN 
DECLARE total_sales_value float;
SELECT SUM(P.amount) INTO total_sales_value
FROM payment P
JOIN staff S USING (staff_id)
GROUP BY store_id
HAVING store_id = store;
SELECT total_sales_value INTO sales;
END //
DELIMITER ;

CALL amount_store(1, @sales1);

SELECT @sales1;

# 5. In the previous query, add another variable flag. 
# If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
# Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

DROP PROCEDURE IF EXISTS amount_store;

DELIMITER //
CREATE PROCEDURE amount_store(IN store int, OUT sales float, OUT flag char(20))
BEGIN 

DECLARE total_sales_value float;
DECLARE color char(20);

SELECT SUM(P.amount) INTO total_sales_value
FROM payment P
JOIN staff S USING (staff_id)
GROUP BY store_id
HAVING store_id = store;

IF total_sales_value > 30000 THEN 
	SET color = "green_flag";
ELSE 
	SET color = "red_flag";
END IF;

SELECT total_sales_value INTO sales;
SELECT color INTO flag;

END //
DELIMITER ;

CALL amount_store(1, @sales1, @flag1);

SELECT @sales1, @flag1;

CALL amount_store(2, @sales2, @flag2);

SELECT @sales2, @flag2;