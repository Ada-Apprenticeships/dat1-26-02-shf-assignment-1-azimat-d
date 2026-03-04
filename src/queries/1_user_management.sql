.open fittrackpro.db
.mode box

-- 1.1

SELECT
    member_id,
    first_name,
    last_name,
    email,
    join_date
FROM members;

-- 1.2

UPDATE members
SET
    phone_number = '07000 100005',
    email = 'emily.jones.updated@email.com'
WHERE member_id = 5;

-- 1.3

SELECT COUNT(*) AS total_members
FROM members;

-- 1.4

SELECT
    m.member_id,
    m.first_name,
    m.last_name,
    COUNT(ca.class_attendance_id) AS registration_count
FROM members m
JOIN class_attendance ca ON m.member_id = ca.member_id
WHERE ca.attendance_status = 'Registered'
GROUP BY m.member_id, m.first_name, m.last_name
HAVING registration_count = (
    SELECT MAX(cnt) FROM (
        SELECT COUNT(class_attendance_id) AS cnt
        FROM class_attendance
        WHERE attendance_status = 'Registered'
        GROUP BY member_id
    )
);

-- 1.5

SELECT
    m.member_id,
    m.first_name,
    m.last_name,
    COUNT(ca.class_attendance_id) AS registration_count
FROM members m
LEFT JOIN class_attendance ca 
    ON m.member_id = ca.member_id 
    AND ca.attendance_status = 'Registered'
GROUP BY m.member_id, m.first_name, m.last_name
HAVING registration_count = (
    SELECT MIN(cnt) FROM (
        SELECT COUNT(class_attendance_id) AS cnt
        FROM class_attendance
        WHERE attendance_status = 'Registered'
        GROUP BY member_id
    )
);

-- 1.6

SELECT COUNT(*) AS Count
FROM (
    SELECT member_id
    FROM class_attendance
    WHERE attendance_status = 'Attended'
    GROUP BY member_id
    HAVING COUNT(*) >= 2
) AS qualified_members;