--MIS 325 HW 5
--Victoria Vu vtv244

--Question 1
SELECT  SYSDATE as today,
        TO_CHAR(SYSDATE, 'YEAR') as year,
        TO_CHAR(SYSDATE, 'DAY MONTH') as day_month,
        TO_CHAR(SYSDATE, 'MM/DD/YY - ') || 'hour:' || TO_CHAR(SYSDATE, 'hh') as date_with_hours,
        ROUND(365 - TO_CHAR(SYSDATE, 'DDD')) as days_til_end_of_year,
        TO_CHAR(SYSDATE, 'mon day YYYY') as lowercase
FROM dual;

--Question 2
SELECT  reservation_id, customer_id, 
        'Checking in on ' || TO_CHAR(check_in_date, 'Day - Mon DD, YYYY') as arrival_date,
        'at ' || CASE location_id
            WHEN 1 THEN 'South Congress Boutique'
            WHEN 2 THEN 'East 7th Lofts'
            WHEN 3 THEN 'Balcones Canyonlands Cabins'
        END AS location_name,
        NVL(TO_CHAR(notes), ' ') as notes
FROM reservation 
WHERE check_in_date > SYSDATE AND status = 'U'
ORDER BY check_in_date ASC;

--Question 3
SELECT SUBSTR(first_name,1,1) || '. ' || UPPER(last_name) AS customer_name, check_in_date, check_out_date, email
FROM reservation r JOIN customer c ON r.customer_id = c.customer_id
WHERE check_out_date >= SYSDATE - 30
ORDER BY check_out_date;

--Question 4
SELECT r.reservation_id, c.customer_id, TO_CHAR(ro.weekend_rate * 1.1 * 2, '$999.99') AS anticipated_total
FROM room ro 
    JOIN reservation r ON ro.location_id = r.location_id
    JOIN customer c ON r.customer_id = c.customer_id
WHERE check_in_date = '05-NOV-21'
ORDER BY anticipated_total;

--Question 5
SELECT cardholder_last_name, LENGTH(billing_address) AS billing_address_length, ROUND(expiration_date - SYSDATE) AS days_until_card_expiration
FROM customer_payment
ORDER BY days_until_card_expiration;

--Question 6
SELECT  last_name, 
        SUBSTR(address_line_1, 1, (INSTR(address_line_1, ' ') - 1)) AS street_nbr, 
        SUBSTR(address_line_1, (INSTR(address_line_1, ' ') + 1)) AS street_name, 
        NVL(address_line_2, 'n/a') AS address_line_2_listed,
        city, state, zip
FROM customer;

--Question 7
SELECT  first_name || last_name AS customer_name, card_type,
        REPLACE(SUBSTR(card_number,1,4), SUBSTR(card_number,1,4), '****') || '-' ||
        REPLACE(SUBSTR(card_number,5,4), SUBSTR(card_number,5,4), '****') || '-' ||
        REPLACE(SUBSTR(card_number,9,4), SUBSTR(card_number,9,4), '****') || '-' ||
        SUBSTR(card_number, 13, 4) AS redacted_card_num
FROM customer_payment cp JOIN customer c ON cp.customer_id = c.customer_id
WHERE card_type IN ('MSTR','VISA')
ORDER BY last_name;

--Question 8
SELECT  CASE 
        WHEN  stay_credits_earned < 10 THEN '1-Gold Member'
        WHEN  stay_credits_earned >= 10 AND stay_credits_earned < 40 THEN '2-Platinum Member'
        WHEN  stay_credits_earned >= 40 THEN '3-Diamond Club'
        END AS status_level,
        first_name, last_name, email, stay_credits_earned
FROM customer
ORDER BY 1, 3;

--Question 9
SELECT  first_name, last_name, customer_id, email, stay_credits_earned, 
        RANK() OVER (ORDER BY stay_credits_earned DESC) AS rank
FROM customer
WHERE ROWNUM <= 10;

--Question 10
SELECT  *
FROM    (SELECT  first_name, last_name, customer_id, email, stay_credits_earned, 
        RANK() OVER (ORDER BY stay_credits_earned DESC) AS rank
        FROM customer)
WHERE ROWNUM <= 10;
        