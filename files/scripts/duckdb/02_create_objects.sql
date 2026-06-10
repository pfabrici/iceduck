ATTACH 'polariscatalog' AS warehouse (  TYPE ICEBERG , ACCESS_DELEGATION_MODE none );

CREATE SCHEMA IF NOT EXISTS warehouse.iceduck;
CREATE TABLE IF NOT EXISTS warehouse.iceduck.visitors (
    visit_timestamp TIMESTAMP,
    visitor         VARCHAR(20),
    description     VARCHAR(50)
);
