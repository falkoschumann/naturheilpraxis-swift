.headers on
.mode csv
.output emails.csv

SELECT
    surname,
    forename,
    dayofbirth,
    acceptance,
    agency,
    street,
    streetnumber,
    postalcode,
    city,
    country,
    email
FROM
    customerlist
WHERE
    email NOT NULL
    AND email <> ""
;
