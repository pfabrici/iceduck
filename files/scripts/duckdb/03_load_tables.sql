ATTACH 'polariscatalog' AS warehouse (  TYPE ICEBERG , ACCESS_DELEGATION_MODE none );

-- create a reasonable amount of data
INSERT INTO warehouse.iceduck.visitors 
SELECT now(), 'DuckDB', 'created with the DuckDB CLI' FROM range(1,1000000);

SELECT count(*) FROM warehouse.iceduck.visitors;

