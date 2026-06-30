ATTACH 'polariscatalog' AS warehouse (  TYPE ICEBERG , ACCESS_DELEGATION_MODE none );

SET unsafe_enable_version_guessing = true;

--
-- according to the documentation there are two ways to access
-- iceberg tables .
--
-- Let's try the first method which does not use the catalog.
-- it directly scans the table from the s3 bucket :

SELECT *
FROM iceberg_scan('s3://warehouse/iceduck/visitors') 
LIMIT 10;

-- Other way is to query by using details from the 
-- catalog. You can then run statements on table names
-- as in this example that
-- checks the number of rows in the visitors table
--
SELECT count(*) FROM warehouse.iceduck.visitors;

-- with the DuckDB iceberg_functions  we are able to access
-- the table metadata as well. iceberg_metadate gives back
-- detailed information on all data and manifest files which
-- compose the table which is given by the path in the parameter :
--
SELECT * FROM iceberg_metadata('s3://warehouse/iceduck/visitors');

-- with iceberg_snapshots it is possible to query all available
-- snapshots of a certain table
SELECT * FROM iceberg_snapshots('s3://warehouse/iceduck/visitors');

