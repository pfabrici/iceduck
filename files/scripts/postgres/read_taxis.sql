
\c iceduck

--  Read data from S3 using the pg_duckdb extension
--
SET duckdb.force_execution = true;
SELECT duckdb.install_extension('httpfs','iceberg');
SELECT duckdb.load_extension('httpfs','iceberg');

SELECT duckdb.raw_query($$CREATE SECRET s3_secret( TYPE s3, PROVIDER config, KEY_ID 'duckdb',SECRET 'password', region 'us-east-1', ENDPOINT 'minio:9000', use_ssl false)$$);
SELECT duckdb.query('SELECT * FROM duckdb_secrets()');

SELECT count(*) FROM read_parquet('s3://warehouse.minio/nyc/taxis/*.parquet');

--  now access the tables using the Iceberg extension :
--
SELECT duckdb.raw_query($$CREATE SECRET iceberg_secret( TYPE iceberg, TOKEN 'dummy');$$);
SELECT duckdb.raw_query($$ATTACH 'warehouse' AS warehouse ( TYPE iceberg, ENDPOINT 'http://rest:8181'); $$);
SELECT duckdb.raw_query($$SET unsafe_enable_version_guessing = true; $$);


