.open fittrackpro.db
.mode box

-- 4.1 

SELECT
    c.class_id,
    c.name AS class_name,
    s.first_name || ' ' || s.last_name AS instructor_name
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id
JOIN staff s ON cs.staff_id = s.staff_id
GROUP BY c.class_id, c.name, s.staff_id;

-- 4.2 

SELECT
    c.class_id,
    c.name,
    cs.start_time,
    cs.end_time,
    c.capacity - COUNT(ca.class_attendance_id) AS available_spots
FROM class_schedule cs
JOIN classes c ON cs.class_id = c.class_id
LEFT JOIN class_attendance ca
    ON cs.schedule_id = ca.schedule_id
    AND ca.attendance_status IN ('Registered', 'Attended')
WHERE date(cs.start_time) = '2025-02-01'
GROUP BY cs.schedule_id, c.class_id, c.name, cs.start_time, cs.end_time, c.capacity
HAVING available_spots > 0
ORDER BY cs.start_time;

-- 4.3 

INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
SELECT 8, 11, 'Registered'
WHERE NOT EXISTS (
    SELECT 1 FROM class_attendance
    WHERE schedule_id = 8 AND member_id = 11
);

-- 4.4 

DELETE FROM class_attendance
WHERE schedule_id = 7
AND member_id = 3;

-- 4.5 

SELECT
    c.class_id,
    c.name AS class_name,
    COUNT(ca.class_attendance_id) AS registration_count
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id
JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id
WHERE ca.attendance_status = 'Registered'
GROUP BY c.class_id, c.name
HAVING registration_count = (
    SELECT MAX(cnt) FROM (
        SELECT COUNT(class_attendance_id) AS cnt
        FROM class_attendance
        WHERE attendance_status = 'Registered'
        GROUP BY schedule_id
    )
);

-- 4.6 

SELECT
    ROUND(CAST(COUNT(ca.class_attendance_id) AS REAL) / COUNT(DISTINCT ca.member_id), 2) AS avg_classes_per_member
FROM class_attendance ca
WHERE ca.attendance_status IN ('Registered', 'Attended');


-- .read src/queries/4_class_scheduling.sql
