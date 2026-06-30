
-- create the iceduck schema and visitors table 
-- in Iceduck 
-- by using SparkSQL
-- if it does not exist already

CREATE SCHEMA IF NOT EXISTS iceduck;

CREATE TABLE IF NOT EXISTS iceduck.visitors (
    visit_timestamp TIMESTAMP,
    visitor         VARCHAR(20),
    description     VARCHAR(50)
);

ALTER TABLE iceduck.visitors SET TBLPROPERTIES (
    'write.parquet.compression-codec' = 'zstd',
    'write.target-file-size-bytes' = '268435456'
);
