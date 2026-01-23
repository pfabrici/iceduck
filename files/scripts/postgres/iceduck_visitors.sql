\c iceduck
SELECT duckdb.install_extension('iceberg');
--  Read data from S3 using the pg_duckdb extension
--
SET duckdb.force_execution = true;

SELECT duckdb.create_simple_secret(
    type := 'S3', 
    key_id := :'AWS_ACCESS_KEY_ID', 
    secret := :'AWS_SECRET_ACCESS_KEY', 
    region := :'AWS_REGION',
    endpoint := :'AWS_ENDPOINT',
    use_ssl := 'false',
    url_style := 'path'
);

SELECT duckdb.create_simple_secret(
    type := 'Iceberg', 
    client_id := :'POLARIS_ROOT_CLIENT_ID', 
    client_secret := :'POLARIS_ROOT_CLIENT_SECRET', 
    endpoint := 'http://rest:8181/api/catalog'
);

SELECT duckdb.raw_query(
            CONCAT('ATTACH ''', :'POLARIS_CATALOG_NAME', ''' AS polaris_catalog ( ', 
            ' TYPE ICEBERG ',
            ', ENDPOINT ''http://rest:8181/api/catalog'' )')
);


/*
WITH 
    ice_init_sqls AS (
        SELECT 
            1   as ordnum,
            CONCAT(
            'CREATE SECRET s3_secret( ',
            ' TYPE s3, PROVIDER config ',
            ', KEY_ID ''',:'AWS_ACCESS_KEY_ID','''',
            ', SECRET ''',:'AWS_SECRET_ACCESS_KEY', '''', 
            ', URL_STYLE ''path'' '
            ', ENDPOINT ''', :'AWS_ENDPOINT', '''',
            ', REGION ''' ,:'AWS_REGION', '''', 
            ', USE_SSL false)'
            ) AS sqlcmd
        UNION
        SELECT 
            2   as ordnum,
            CONCAT(
            'CREATE SECRET polaris_secret( ',
            ' TYPE iceberg ',
            ', CLIENT_ID ''',:'POLARIS_ROOT_CLIENT_ID','''',
            ', CLIENT_SECRET ''',:'POLARIS_ROOT_CLIENT_SECRET', '''', 
            ', ENDPOINT ''http://rest:8181/api/catalog'' )'
            ) AS sqlcmd
        UNION
        SELECT 
            3   as ordnum,
            CONCAT(
            'ATTACH ''', :'POLARIS_CATALOG_NAME', ''' AS polaris_catalog ( ', 
            ' TYPE ICEBERG ',
            ', ENDPOINT ''http://rest:8181/api/catalog'' )'
            ) AS sqlcmd
    ) 
SELECT 
    duckdb.raw_query(sqlcmd) 
FROM 
    ice_init_sqls
ORDER BY 
    ordnum;    
*/

SELECT 
    *
FROM    
    duckdb.query('SELECT * FROM duckdb_secrets()');


