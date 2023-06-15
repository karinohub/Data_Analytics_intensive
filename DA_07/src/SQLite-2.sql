SELECT ROUND(AVG(count_time), 2)
FROM (SELECT COUNT(purch.event_time) AS count_time
      FROM da_project05_purch purch
      LEFT JOIN da_project05_events events
      ON purch.user_id = events.user_id AND purch.product_id = events.product_id
      WHERE  purch.event_time >= events.event_time AND events.event_type = 'view'
      GROUP BY purch.event_time, purch.user_id)

SELECT ROUND(AVG(count_time), 2) as avg_view, code
FROM (SELECT COUNT(purch.event_time) AS count_time, purch.category_code AS code
      FROM da_project05_purch purch
      LEFT JOIN da_project05_events events
      ON purch.user_id = events.user_id AND purch.product_id = events.product_id
      WHERE  purch.event_time >= events.event_time AND events.event_type = 'view' AND purch.category_code LIKE '%computers%'
      GROUP BY purch.event_time, purch.user_id) 
GROUP BY code
ORDER BY avg_view DESC

SELECT month_ AS Month, COUNT(user) as Total, SUM(user_flag) AS Payers
FROM (SELECT MAX(CASE   
                 when user_id NOTNULL THEN "1"
                 ELSE "0"
                 END) AS user_flag, count(user), user, month_
      FROM (SELECT COALESCE(purch.user_id, events.user_id) as user, COALESCE(purch.month, events.month) as month_, * 
            FROM da_project05_purch purch
            FULL JOIN da_project05_events events
            ON purch.user_id = events.user_id) AS full_table
      GROUP BY user, month_) AS table_flag
GROUP BY month_

