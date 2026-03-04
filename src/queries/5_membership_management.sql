.open fittrackpro.db
.mode box

-- 5.1 

SELECT
    m.member_id,
    m.first_name,
    m.last_name,
    ms.type AS membership_type,
    m.join_date
FROM members m
JOIN memberships ms ON m.member_id = ms.member_id
WHERE ms.status = 'Active'
ORDER BY m.member_id;

-- 5.2 

SELECT
    ms.type AS membership_type,
    ROUND(AVG((julianday(a.check_out_time) - julianday(a.check_in_time)) * 1440), 2) AS avg_visit_duration_minutes
FROM attendance a
JOIN memberships ms ON a.member_id = ms.member_id
WHERE a.check_out_time IS NOT NULL
GROUP BY ms.type
ORDER BY ms.type;

-- 5.3 

SELECT
    m.member_id,
    m.first_name,
    m.last_name,
    m.email,
    ms.end_date
FROM members m
JOIN memberships ms ON m.member_id = ms.member_id
WHERE strftime('%Y', ms.end_date) = '2025'
ORDER BY ms.end_date;
