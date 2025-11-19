## Iceduck
### Abstract
DataLakes are getting more and more common, but infrastructure is often based on proprietary SaaS offerings or very complex to setup. Beside that, many developers that are used to work in traditional DWH environments with visual ETL tools and SQL face a transition to a new tooling e.g. with Spark/PySpark which makes transitions to DataLake environments more complex.

[DuckDBs](https://duckdb.org) capabilties of [Apache Iceberg](https://iceberg.apache.org) promise an easy integration of an DataLakish storage layer into a tool based ELT/ETL process.

Iceduck examines a tool setup that enables to
- read ("extract") data from any sources with [Apache Hop](https://hop.apache.org)
- use Apache Hop to write ("load") this data to [Apache Iceberg](https://iceberg.apache.org) tables in an object storage like S3 or MinIO using [DuckDB](https://duckdb.org) 
- integrate the Iceberg tables into a [Postgres](https://postgresql.org) database using [pg_duckdb](https://github.com/duckdb/pg_duckdb) 
- transform this data with [dbt](https://www.getdbt.com)

The Iceduck repo is based on docker and docker compose so you will need an appropriate environment to run it.






```docker compose up -d``` creates a new Postgres DB

## pg_duckdb




SELECT duckdb.create_simple_secret(    type := 'S3',    key_id := 'admin',    secret := 'password',    region := 'us-east-1',    endpoint := 'minio:9000',    url_style := 'path',    use_ssl := 'false');
SELECT duckdb.create_simple_secret(    type := 'ICEBERG',    key_id := null,    secret := null,    region := 'us-east-1',        session_token := 'dummy');      

select duckdb.raw_query('CREATE OR REPLACE SECRET minio_s3 (  TYPE S3,  KEY_ID  "admin",  SECRET  "password",  ENDPOINT "minio:9000",  URL_STYLE "path",  USE_SSL false)');
select duckdb.raw_query('CREATE OR REPLACE SECRET iceberg_rest (  TYPE ICEBERG,  TOKEN 'dummy')');
select duckdb.raw_query('CREATE OR REPLACE SECRET iceberg_rest (  TYPE ICEBERG,  TOKEN "dummy")');
select duckdb.raw_query('ATTACH IF NOT EXISTS "warehouse" AS warehouse (  TYPE ICEBERG,  ENDPOINT "http://iceberg-rest:8181",  SECRET iceberg_rest)');
select duckdb.raw_query('ATTACH IF NOT EXISTS warehouse AS warehouse (  TYPE ICEBERG,  ENDPOINT "http://iceberg-rest:8181",  SECRET iceberg_rest)');
select duckdb.raw_query("ATTACH IF NOT EXISTS warehouse AS warehouse (  TYPE ICEBERG,  ENDPOINT 'http://iceberg-rest:8181',  SECRET iceberg_rest)");
select duckdb.raw_query('ATTACH IF NOT EXISTS ''warehouse'' AS warehouse (  TYPE ICEBERG,  ENDPOINT ''http://iceberg-rest:8181'',  SECRET iceberg_rest)');

