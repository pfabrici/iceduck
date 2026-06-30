USE iceduck;

INSERT INTO visitors ( visit_timestamp, visitor, description)
SELECT now(), 'SparkSQL', 'created with the SparkSQL CLI' FROM range(1,1000000);

SELECT count(*) FROM visitors;

