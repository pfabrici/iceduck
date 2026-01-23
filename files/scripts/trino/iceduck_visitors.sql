SHOW CATALOGS;

CREATE SCHEMA IF NOT EXISTS warehouse.iceduck;
USE warehouse.iceduck;

CREATE TABLE IF NOT EXISTS visitors (
    visit_timestamp TIMESTAMP,
    visitor         VARCHAR(20),
    description     VARCHAR(50)
);

INSERT INTO warehouse.iceduck.visitors VALUES ( now(), 'Trino', 'created with the Trino CLI' );
SELECT * FROM warehouse.iceduck.visitors ORDER BY 1 DESC;