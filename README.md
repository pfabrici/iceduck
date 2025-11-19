## 

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

