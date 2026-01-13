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
All wrapper scripts need to be started from the main folder of the repo.

#### MinIO
The MinIO administration tool *mc*, that is helpfull for managing buckets, access etc., can be started using the ``bin/mc`` wrapper. As ``./iceduck init`` uses this script during the initialization phase, too, a connection alias *minio* to your local MinIO instance has already been created.

After running ``bin/mc`` a docker container running with a shell is started. Within you can now run mc commands, e.g. 
```
mc ls minio/warehouse
```
Alternatively it is possible to pass command files to ``bin/mc``, e.g. ``cat mcscript.sh | bin/mc``

With a browser you might connect to the MinIO administrative WebUI at ``http://localhost:9001``. The credentials are admin/password, as long as you do not change them in etc/iceduck before a *iceduck init*.

See the MinIO documentation for further instructions.

#### Trino
There is another wrapper script to access the Trino command line interface. Use ``bin/trino`` to start and connect. You can then run Trino commands, e.g.
```
SHOW CATALOGS
```
which would show you that there are already two catalogs ( warehouse and pgice ) created.

At ``http://localhost:8060`` you can access the Trino cluster overview, which shows you current run details of the ( one-node) Trino cluster.

### Polaris
The configuration of Polaris essentially involves managing catalogs and rights and bootstrapping a catalog at the beginning. The configuration is mainly done by calling API endpoints, which can be done with curl. Some tasks like bootstrapping are only supported by cli calls.

Therefore Iceduck contains two wrapper scripts, that start specialized docker containers : 

* ``bin/iceshell`` opens a bash shell with curl, iceduck environment variables and network set 
* ``bin/poladm`` is based on a container with the polaris admin tools. It contains e.g. the bootstrap command.

Both commands are used in the *iceduck* init section as well.

### Postgres
Postgres is acccessible by two different ways as well :
* Docker Port 5432 is open, so you can easily connect to the database using a (JDBC) client tool
* ``bin/psql`` starts psql directly in the container using the postgres user.

### Jupyter/Spark

Jupyter Notebooks can be accessed at (http://localhost:8888) . 
See the running spark jobs at (http://localhost:8080)



## References
https://medium.com/@gilles.philippart/build-a-data-lakehouse-with-apache-iceberg-polaris-trino-minio-349c534ecd98