WITH ranked AS 
(
 SELECT
  emplid,
  dep,
  salary,
  RANK() OVER (PARTITION BY dep ORDER BY salary DESC) AS rnk
  FROM test
)
SELECT emplid
FROM ranked
WHERE rnk = 1