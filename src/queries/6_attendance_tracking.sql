.open fittrackpro.db
.mode box

-- 6.1 

INSERT INTO attendance (member_id, location_id, check_in_time, check_out_time)
VALUES (7, 1, '2025-02-14 16:30:00', NULL);

-- 6.2 

SELECT
    date(check_in_time) AS visit_date,
    check_in_time,
    check_out_time
FROM attendance
WHERE member_id = 5
ORDER BY check_in_time;

-- 6.3 

SELECT
    CASE strftime('%w', check_in_time)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS visit_count
FROM attendance
GROUP BY strftime('%w', check_in_time)
HAVING visit_count = (
    SELECT MAX(cnt) FROM (
        SELECT COUNT(*) AS cnt
        FROM attendance
        GROUP BY strftime('%w', check_in_time)
    )
);

-- 6.4 

WITH date_range AS (
    SELECT
        CAST(
            julianday(MAX(date(check_in_time))) -
            julianday(MIN(date(check_in_time))) + 1
        AS INTEGER) AS total_days
    FROM attendance
)
SELECT
    l.name AS location_name,
    ROUND(CAST(COUNT(a.attendance_id) AS REAL) / (SELECT total_days FROM date_range), 2) AS avg_daily_attendance
FROM locations l
LEFT JOIN attendance a ON l.location_id = a.location_id
GROUP BY l.location_id, l.name
ORDER BY l.location_id;
