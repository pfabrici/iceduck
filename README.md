# Iceduck
## Abstract
DataLakes are getting more and more common, but infrastructure is often based on proprietary SaaS offerings. Fortunatly it is possible to use open software to put together an infrastructure stack at least for learning or development purposes. This makes gaining knowledge without following the companies marketing promises or being limited to one packaged stack a lot easier.

IceDuck offers a DataLake infrastructure based on:
- MinIO, the object storage
- Trino, an SQL engine
- Apache Polaris, a catalog for Apache Iceberg
- Postgres as the metastore for Apache Polaris and example for traditional data store
- Jupyter and Spark as an data exploration platform

Postgres has the DuckDB extension installed, so that it is possible to access Iceberg tables from the database.
The setup is not meant to be used in production environments.

With this a lot of use cases might be investigated. Just to name a few :
- use Trino as a query tool for Apache Iceberg tables
- compare Postgres/DuckDB to Trino as query tools for Apache Iceberg
- connect (E)TL tools like dbt or Apache Hop to an Apache Iceberg DataLake using Trino as query engine
- connect Reporting Tools like Apache Superset to Apache Iceberg using Postgres/DuckDB

Beside, it is simply possible to learn the basics of SparkSQL, PySpark, Iceberg etc.

IceDuck got its name, because the original intention was to explore the DuckDB capabilties in combination with Apache Iceberg tables. On the way Trino, Jupyter, Spark etc. was added but the name stayed.

## Usage
### Requirements
Make sure that you have git and docker+compose installed on your linux box. git clone the iceduck repository.
### Starting, stopping, initializing
For convenience reasons a simple wrapper script *iceduck* is provided in the main folder of the repository. It accepts a couple of commands as parameter:
- *./iceduck clean* tries to docker down the stack and removes all runtime data from the folders
- *./iceduck init* prepares all configuration files based on the configurations in etc/iceduck.env and tries to start the stack afterwards. This should be used at the very first start or after issuing *./iceduck clean*
- *./iceduck start* is equivalent to a docker compose up -d
- *./iceduck stop* is equivalent to a docker compose down

### Accessing services
#### MinIO
The administration tool *mc* can be started using ``bin/mc``. As ``./iceduck init`` uses this script, too, a connection alias *minio* to your local MinIO instance has already been created.

After running ``bin/mc`` a docker container running with a shell is started. Within you can now run mc commands, e.g. 
```
mc ls minion/warehouse
```
Alternatively it is possible to pass command files to ``bin/mc``, e.g. ``cat mccmds.sh | bin/mc``

Using a browser you might connect to the MinIO administrative WebUI  at ``http://localhost:9000``. The credentials are admin/password, as long as you do not change them in etc/iceduck before a *iceduck init*.

See the MinIO documentation for further instructions.

#### Trino
Run 



## References
https://medium.com/@gilles.philippart/build-a-data-lakehouse-with-apache-iceberg-polaris-trino-minio-349c534ecd98