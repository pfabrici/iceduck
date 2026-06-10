
CREATE PERSISTENT SECRET s3_secret( 
    TYPE s3, 
    KEY_ID getenv('AWS_ACCESS_KEY_ID'), 
    SECRET getenv('AWS_SECRET_ACCESS_KEY'), 
    REGION getenv('AWS_REGION'), 
    ENDPOINT getenv('AWS_ENDPOINT'), 
    URL_STYLE 'path', 
    USE_SSL 'false' 
);

CREATE PERSISTENT SECRET polaris_secret(  
    TYPE iceberg , 
    CLIENT_ID getenv('POLARIS_ROOT_CLIENT_ID'), 
    CLIENT_SECRET getenv('POLARIS_ROOT_CLIENT_SECRET'), 
    ENDPOINT 'http://rest:8181/api/catalog' 
);

ATTACH 'polariscatalog' AS warehouse (  TYPE ICEBERG , ACCESS_DELEGATION_MODE none );

CREATE SCHEMA IF NOT EXISTS warehouse.iceduck;
CREATE TABLE IF NOT EXISTS warehouse.iceduck.visitors (
    visit_timestamp TIMESTAMP,
    visitor         VARCHAR(20),
    description     VARCHAR(50)
);
