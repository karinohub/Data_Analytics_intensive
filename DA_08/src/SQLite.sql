WITH a_cte AS ( SELECT events.user_id, events.user_session, min(events.event_time) OVER(PARTITION BY events.user_session) AS start_time,
	   CASE WHEN purch.user_session is NULL 
			then 0 
            else 1 
            end as is_purchase
FROM da_project05_events events
LEFT JOIN da_project05_purch purch ON events.user_session = purch.user_session
GROUP BY events.user_id, events.user_session, is_purchase),
	b_cte AS (SELECT *, row_number() OVER(PARTITION BY user_id ORDER BY start_time) AS session_num --, MIN(a.session_num) OVER(PARTITION BY user_id ORDER BY is_purchase RANGE 1) AS min_num
			  FROM a_cte),
    c_cte AS (SELECT *, min(session_num) OVER(PARTITION BY user_id) AS min_num
              FROM b_cte
              WHERE is_purchase = 1)
SELECT ROUND(AVG(min_num), 0) AS avg_number_of_sessions
FROM c_cte

WITH a_cte AS (SELECT strftime('%Y-%m-%d', event_time) AS day, user_id
               FROM 
               (SELECT * FROM da_project05_events
                UNION ALL 
                SELECT * FROM da_project05_purch)
              GROUP BY day, user_id),
	 b_cte AS (SELECT *, min(day) OVER(PARTITION BY user_id) AS reg_day
               FROM a_cte),
     c_cte AS (SELECT date(max(day), '-28 days') AS day_28 FROM a_cte),
     d_cte AS (SELECT *, JULIANDAY(day) - JULIANDAY(reg_day) AS day_diff
               FROM b_cte
               Join c_cte ON reg_day <= c_cte.day_28)

SELECT day_diff, COUNT(DISTINCT user_id) AS daily_active_users
FROM d_cte
WHERE day_diff <= 28
GROUP BY day_diff
ORDER BY day_diff;