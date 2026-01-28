install httpfs;
load httpfs;

set s3_endpoint=getenv('AWS_ENDPOINT'); -- 'minio:9000';
set s3_url_style='path';
set s3_use_ssl='false';
SET s3_region=getenv('AWS_REGION');
SET s3_access_key_id=getenv('AWS_ACCESS_KEY_ID');
SET s3_secret_access_key=getenv('AWS_SECRET_ACCESS_KEY');

-- CREATE SECRET s3_secret( TYPE s3, KEY_ID getenv('AWS_ACCESS_KEY_ID'), SECRET getenv('AWS_SECRET_ACCESS_KEY'), ENDPOINT getenv('AWS_ENDPOINT'), URL_STYLE 'path', USE_SSL 'false' );
CREATE SECRET polaris_secret(  TYPE iceberg , CLIENT_ID getenv('POLARIS_ROOT_CLIENT_ID'), CLIENT_SECRET getenv('POLARIS_ROOT_CLIENT_SECRET'), ENDPOINT 'http://rest:8181/api/catalog' );
ATTACH 'polariscatalog' AS warehouse (  TYPE ICEBERG , ENDPOINT 'http://rest:8181/api/catalog', ACCESS_DELEGATION_MODE none );


CREATE SCHEMA IF NOT EXISTS warehouse.iceduck;
CREATE TABLE IF NOT EXISTS warehouse.iceduck.visitors (
    visit_timestamp TIMESTAMP,
    visitor         VARCHAR(20),
    description     VARCHAR(50)
);

INSERT INTO warehouse.iceduck.visitors VALUES ( now(), 'DuckDB', 'created with the DuckDB CLI' );
SELECT * FROM warehouse.iceduck.visitors ORDER BY 1 DESC;