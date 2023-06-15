SELECT COUNT(id) FROM da_project05_purch;

SELECT category_code, COUNT(category_code) AS sum FROM da_project05_purch GROUP BY category_code ORDER BY sum DESC;

SELECT COUNT(DISTINCT user_id) FROM da_project05_purch;

SELECT brand, COUNT(product_id) AS sum FROM da_project05_purch GROUP BY brand  ORDER BY sum DESC;

SELECT month, ROUND(SUM(price), 2) AS sum FROM da_project05_purch GROUP BY month  ORDER BY sum DESC;

#extra 

SELECT DISTINCT product_id, category_code, brand, price FROM da_project05_purch ORDER BY price LIMIT 1;
 
SELECT COUNT(product_id) FROM da_project05_purch WHERE product_id = 167240;

SELECT user_id, COUNT(user_id) FROM da_project05_purch GROUP BY user_id ORDER BY COUNT(user_id) DESC LIMIT 1;

SELECT user_id, ROUND(SUM(price), 2) as sum FROM da_project05_purch GROUP BY user_id ORDER BY sum DESC LIMIT 1;

SELECT user_id, user_session, product_id, COUNT(product_id) FROM da_project05_purch WHERE user_id = 1515915625601579158 GROUP BY user_session ORDER BY COUNT(product_id) DESC ;

SELECT user_id, user_session, product_id, COUNT(product_id) FROM da_project05_purch WHERE user_id = 1515915625601579158 GROUP BY product_id ORDER BY COUNT(product_id) DESC ;
