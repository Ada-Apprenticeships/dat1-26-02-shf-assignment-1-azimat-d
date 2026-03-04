.open fittrackpro.db
.mode box

-- 7.1 

SELECT
    staff_id,
    first_name,
    last_name,
    position AS role
FROM staff
ORDER BY position;

-- 7.2 

SELECT
    s.staff_id AS trainer_id,
    s.first_name || ' ' || s.last_name AS trainer_name,
    COUNT(pts.session_id) AS session_count
FROM staff s
JOIN personal_training_sessions pts ON s.staff_id = pts.staff_id
WHERE
    s.position = 'Trainer'
    AND pts.session_date >= '2025-01-20'
    AND pts.session_date <= date('2025-01-20', '+30 days')
GROUP BY s.staff_id, trainer_name
HAVING session_count >= 1
ORDER BY session_count DESC;


--.read src/queries/7_staff_management.sql
