CREATE SCHEMA IF NOT EXISTS iceduck;

CREATE TABLE IF NOT EXISTS iceduck.visitors (
    visit_timestamp TIMESTAMP,
    visitor         VARCHAR(20),
    description     VARCHAR(50)
);

INSERT INTO iceduck.visitors VALUES ( now(), 'SparkSQL', 'created with SparkSql using the CLI' );

SELECT * FROM iceduck.visitors ORDER BY 1 DESC;