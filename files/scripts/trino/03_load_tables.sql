
INSERT INTO warehouse.iceduck.visitors 
SELECT  now(), 'Trino', 'created with the Trino CLI'
FROM TABLE(sequence(
                start => 1,
                stop => 1000000,
                step => 1));
