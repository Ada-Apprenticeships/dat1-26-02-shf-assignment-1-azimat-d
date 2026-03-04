.open fittrackpro.db
.mode box

-- 2.1 

INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (
    11,
    50.00,
    datetime('now'),
    'Credit Card',
    'Monthly membership fee'
);

-- 2.2 

SELECT
    strftime('%Y-%m', payment_date) AS month,
    SUM(amount) AS total_revenue
FROM payments
WHERE
    payment_type = 'Monthly membership fee'
    AND payment_date >= '2024-11-01'
    AND payment_date < '2025-03-01'
GROUP BY month
ORDER BY month;

-- 2.3 

SELECT
    payment_id,
    amount,
    payment_date,
    payment_method
FROM payments
WHERE payment_type = 'Day pass';

-- .read src/queries/2_payment_management.sql
