https://datalens.yandex/br3nj15pnd4u1

CREATE TABLE monthly_purchases AS 
  WITH sum_purch_mounth AS (
  SELECT SUM(amount) AS sum_purch, STRFTIME('%Y/%m', transacion_date) AS month
  FROM item_purchases
  GROUP BY month)
SELECT SUM(sum_purch) OVER (ORDER BY month) AS cumulative_revenue, month, sum_purch
FROM sum_purch_mounth;


CREATE TABLE first_logins AS SELECT logins.username, STRFTIME('%Y/%m/%d', register_date) AS reg_day, STRFTIME('%Y/%m/%d', login_date) AS log_day
							 FROM logins LEFT JOIN app_installs ON logins.username = app_installs.username
							 WHERE STRFTIME('%Y/%m/%d', register_date) = STRFTIME('%Y/%m/%d', login_date)

CREATE TABLE arpu_arppu AS 
						WITH arpu_cte AS (select  count(DISTINCT username) AS number_of_users, STRFTIME('%Y/%m', login_date) AS month
                  						  FROM logins
                  						  GROUP BY month),
     		 				 arppu_cte AS (select  count(DISTINCT username) AS number_of_purchase_users, SUM(amount) AS sum_purch, STRFTIME('%Y/%m', transacion_date) AS month
                   	   		 			   FROM item_purchases
                   	  					   GROUP BY month)
                        SELECT sum_purch, number_of_users, number_of_purchase_users, arpu_cte.month 
						FROM arpu_cte LEFT JOIN arppu_cte ON arpu_cte.month = arppu_cte.month;

CREATE TABLE retention AS WITH reg_month AS (
  			   SELECT username, register_date, STRFTIME('%Y/%m', register_date) AS month_registered
  			   FROM app_installs),
-- выборка когорт и количества уникальных пользователей в каждой когорте
	   count_reg AS (
       SELECT month_registered, COUNT(DISTINCT username) AS all_users
                FROM reg_month
                GROUP BY 1),
-- выборка количества пользователей, которые вернулись в игру на 7 и 28 день после регистрации для каждой когорты

	 retention AS (SELECT month_registered, login_day, COUNT(DISTINCT username) AS retained_users, day_diff
                   FROM (SELECT month_registered, username, DATE(login_date) AS login_day,
  						JULIANDAY(DATE(login_date)) - JULIANDAY(DATE(register_date)) AS day_diff
  						FROM logins JOIN reg_month USING (username))
				   WHERE day_diff IN (7, 28)
				   GROUP BY 1, 4)
SELECT * from retention JOIN count_reg USING (month_registered)

WITH a_cte AS (SELECT strftime('%Y-%m-%d', login_date) AS day, logins.username, strftime('%Y-%m-%d', register_date) AS reg_date, COUNT(logins.username)
               FROM logins
               LEFT JOIN app_installs ON app_installs.username = logins.username
               GROUP BY logins.username, day),
     c_cte AS (SELECT date(max(day), '-28 days') AS day_28 FROM a_cte),
     d_cte AS (SELECT *, JULIANDAY(day) - JULIANDAY(reg_date) AS day_diff
               FROM a_cte
               Join c_cte ON reg_date <= c_cte.day_28)

SELECT day_diff, COUNT(DISTINCT username) AS daily_active_users
FROM d_cte
WHERE day_diff <= 28
GROUP BY day_diff
ORDER BY day_diff;
