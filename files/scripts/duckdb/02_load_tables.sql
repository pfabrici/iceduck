ATTACH 'polariscatalog' AS warehouse (  TYPE ICEBERG , ACCESS_DELEGATION_MODE none );

INSERT INTO warehouse.iceduck.visitors VALUES ( now(), 'DuckDB', 'created with the DuckDB CLI' );
SELECT * FROM warehouse.iceduck.visitors ORDER BY 1 DESC;