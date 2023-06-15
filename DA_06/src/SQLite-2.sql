SELECT category_code, COUNT(category_code) 
FROM da_project05_purch
WHERE user_id IN (SELECT user_id 
                  FROM da_project05_purch
                  WHERE category_code LIKE "%videocard%" AND brand = "msi")
      AND (category_code NOT LIKE "%videocard%" AND brand != "msi")
GROUP BY category_code
ORDEr BY COUNT(category_code) DESC;

SELECT strftime("%H", event_time) AS happy_hour, COUNT(strftime("%H", event_time)) AS n_hours
FROM da_project05_purch
WHERE category_code LIKE "%videocard%"
GROUP BY happy_hour
ORDER BY n_hours DESC;




with res_cte AS (
  SELECT ROUND(SUM(price)/COUNT(user_id), 2) as avg_check, user_id, MAX(CASE
                                                                        when category_code = "computers.components.videocards" THEN "1"
                                                                        ELSE "0"
                                                                        END) AS buy
  FROM da_project05_purch 
  GROUP BY user_id )

SELECT buy, ROUND(SUM(avg_check)/COUNT(user_id), 2)
FROM res_cte
GROUP BY buy



SELECT COUNT(user_id), user_id, MAX(CASE   
	when category_code = "computers.components.videocards" THEN "1"
    ELSE "0"
    END) AS buy
FROM da_project05_purch 
GROUP BY user_id
ORDER BY buy DESC




