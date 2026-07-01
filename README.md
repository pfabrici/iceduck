# 🏞️ Iceduck: Open-Source Data Lakehouse Stack

[![GitHub License](https://img.shields.io/github/license/pfabrici/iceduck)](https://github.com/pfabrici/iceduck/blob/main/LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/pfabrici/iceduck?style=social)](https://github.com/pfabrici/iceduck/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/pfabrici/iceduck)](https://github.com/pfabrici/iceduck/issues)
![Docker](https://img.shields.io/badge/Docker-Ready-brightgreen)
![Apache Iceberg](https://img.shields.io/badge/Apache%20Iceberg-1.4.0-blue)
![Trino](https://img.shields.io/badge/Trino-470-blue)
![Spark](https://img.shields.io/badge/Apache%20Spark-3.5.0-orange)
![DuckDB](https://img.shields.io/badge/DuckDB-0.10.0-blue)
![MinIO](https://img.shields.io/badge/MinIO-Object%20Storage-blue)

---

## **What is Iceduck?**
**Iceduck** is an **open-source Data Lakehouse stack** designed for **learning, prototyping, and testing** modern data architectures **locally**—without cloud dependencies or proprietary SaaS solutions.

It provides a **Docker Compose-based environment** with:
- **MinIO** as the underlying **S3-compatible object storage**
- **Apache Polaris** as a **REST catalog for Apache Iceberg**
- **Trino** as a **distributed SQL query engine** (accessing Iceberg, Postgres, and more)
- **Postgres** as the **metastore for Polaris** and a traditional relational store
- **Spark** as a **distributed query and processing platform**
- **DuckDB** for **fast analytical queries** on Iceberg tables
- **Jupyter Notebooks** for **interactive exploration** with Spark and Python

---

## **Why Use Iceduck?**
Data Lakes and Data Lakehouses are **replacing traditional data warehouses** for modern analytics, but most infrastructure solutions are **proprietary or cloud-locked** (e.g., Databricks, Snowflake, or AWS/GCP services). This makes it **difficult to learn the core open-source technologies** behind these systems—such as **Apache Iceberg, Trino, or MinIO**—without vendor dependencies.

The project started as an exploration of **DuckDB + Apache Iceberg** capabilities. Along the way, Trino, Spark, Jupyter, and other tools were added—but the name stuck!

Tutorials, Results and documentation of my investigations with Iceduck.

## **How to use this Data Lakehouse**
This platform was originally used to explore the capabilities of a Data Lakehouse. You can find the write-ups of the findings in the doc section. Here are some links to further readings :

* [Using the DuckDB CLI](doc/Using_DuckDB_CLI.md)

---

## **Quickstart**
Iceduck is designed to be as easy as running a single script with some command options. Here’s how to get started:

### **Prerequisites**
- **Docker** + **Docker Compose** (tested with Docker 24+ and Compose v2+)
- **Linux/Unix environment** (wrapper scripts are Bash-based)
- **Git** (to clone the repository)

### **Clone the Repository**
```bash
git clone https://github.com/pfabrici/iceduck.git
cd iceduck
```

### **Run Iceduck**
The ```iceduck``` script located in the main folder of the repo provides functions to handle the entire stack :
| Command | Description |
|---------|----------------------------|
| help | prints out a text that explains the usage of the script |
| init |  prepares the iceduck environment according to the settings in etc/iceduck.env, builds the necessary images, starts the Docker container" and finally creates the demo Users, Buckets and Catalogs |
| clean | reverses the init command, stops the stack and removes all persistent data |
| stop | stops the previously initialized stack without removing data |
| start | starts a previously initialized stack |
| restart | shortcut to stop and start Iceduck |
| status | checks if Iceduck is running |
| build | rebuilds the custom images |

Simply run 
```bash
./iceduck init 
```
from the main folder of the repo to get started.
> **⚠️ Note:** All wrapper scripts must be run from the **main folder** of the repo.

---

## **Start working and interacting with Iceduck**
Once the stack is running, you have a couple of options to interact with the stack. Beside some Web-UIs, Iceduck provides CLI wrappers to directly interact with the services. Some services  expose ports that enable you to connect with 3rd party tools as well.

### **CLI** 
The provided CLI wrappers provide three run modes 
* shell is the default mode and opens an interactive shell where possible
* file is used with the ```-f <file>``` option. It runs all commands in <file> with the cli
* command is executed with ```-c "<command>"```. It executes one single command using the tools cli and exits 
Note that not all wrapper provide all modes.

The wrapper CLIs live in the ```iceduck_net``` Docker network of the whole stack and have therefore access to all internal services. The variables defined in ```etc/iceduck.env``` are made available in the CLI wrappers where possible.

Here is an overview of all available wrappers :

| Wrapper script | Description | ext. Documentation |
|----------------|--------------------|-----|
| bin/duckdb | runs a DuckDB CLI in a Docker container. Uses a persistent workspace. Creates a default DuckDB *iceduck.duckdb* at first usage where you can persist settings and data. Note that you can only run one duckdb wrapper at a time due to locking scenarios. The wrapper is using Iceducks Docker network to allow direct connection to the other services. All Iceduck variables are available in this cli.  | [DuckDB CLI](https://duckdb.org/docs/current/clients/cli/overview)
||Here is a file mode example for *bin/duckdb* that tries to create some objects in the Data Lakehouse: ```bin/duckdb -f files/scripts/duckdb/01_prepare.sql && bin/duckdb -f files/scripts/duckdb/02_create_objects.sql```. There are some more scripts in this folder that demonstrate the use of the wrapper and DuckDB in general.
| bin/iceshell | iceshell is a simple shell that has access to all internal services of the stack. This is useful to run e.g. curl commands on API. It is mainly used in the init scripts. iceshell lives in the same Docker network as the rest of the stack. |
| bin/mc  | mc is the MinIO console. It allows to create and manage buckets and other MinIO objects. Iceduck init creates an alias *minio* that allows you to directly work with the initialized buckets.  | [external mc Documentation](https://minio.github.io/mc/)  | 
| bin/poladm | poladm provides a shell contains the Polaris Admin tool. This is used to bootstrap Polaris by Iceduck init. | [Polaris admin tool](https://polaris.apache.org/releases/1.5.0/admin-tool/) |
| bin/psql | psql starts the Postgres CLI and connects as user *postgres* to the default *postgres* database. There are three predefined databases : postgres(default),polaris(the polaris metastore),iceduck(explorational database with pg_duckdb installed) The wrapper makes all Iceduck variables available. | [Postgres CLI](https://www.postgresql.org/docs/current/app-psql.html) |
| bin/pyspark | this wrapper opens the pyspark cli with a pre-configured Spark Session. There are a couple of Python libraries pre-loaded, see *files/docker/spark/requirements.txt* to see which are available. | [PySpark CLI](https://pyspark.itversity.com/01_getting_started_pyspark/11_launching_pyspark_cli.html)
| bin/sparkshell | |
| bin/sparksql | wrapper allows to directly run Spark-SQL commands. The environment is preconfigured, so it is possible to connect to the Polaris catalog and S3. | [Spark-SQL](https://spark.apache.org/docs/latest/sql-distributed-sql-engine-spark-sql-cli.html) |
|| Here is a file mode examle of *bin/sparksql* that tries to create table objects in the Data Lakehouse ```bin/sparksql -f files/scripts/sparksql/02_create_objects.sql```. There are some more sql files in this folder to demonstrate the use of SparkSQL with the Data Lakehouse.
| bin/trino | The wrapper runs the trino sql cli which has preconfigured access to the Data Lakehouse and the Postgres iceduck DB. The configuration of the pre-configured trino catalogs can be found at *files/data/trino/etc/catalog*   | [Trino SQL](https://trino.io/docs/current/language.html) |
||Here is a file mode example of *bin/trino* that tries to create some table objects in the Data Lakehouse ```bin/trino -f files/scripts/trino/02_create_objects.sql```. There are some more files in this script folder that demonstrate the use of *trino* with the Iceduck Data Lakehouse.

### **WebUI**
Some services provide an WebUI for interaction or monitoring services :

| Service | Purpose | URL | Credentials | 
|---------|--------|-----|-------------|
| **MinIO Web UI** | Dislay and interact with S3 Buckets | [http://localhost:9000](http://localhost:9000) | `admin` / `password` | 
| **Trino Web UI** | view Trino processes | [http://localhost:8060](http://localhost:8060) | `admin` | 
| **Jupyter Notebooks** | write and execute notebooks | [http://localhost:8888](http://localhost:8888) | - | 
| **Spark UI** | View Spark process details | [http://localhost:8080](http://localhost:8080) | - | 

### **Port access**
Some Services provide interfaces as displayed here :

| Service | Purpose | URL | Credentials | 
|---------|--------|-----|-------------|
| **Postgres** | Connect client tools to Postgres with JDBC |`localhost:5432` | `postgres` / `s3cr3t` | 
| **Trino** | Connect client tools to Trino with JDBC |`localhost:8060` | `trino` / `` | 
| **Polaris** | Catalog REST API |`localhost:8181/api/catalog/v1` | |
| **Polaris** | Polaris Management REST API |`localhost:8182` | |

---
## **Predefined Examples**
A collection of scripts working with the stack can be found in *files/scripts* . See the wrapper or WebUI section to see how they can be executed.

---

## **License**
This project is licensed under the **Apache License 2.0** – see the [LICENSE](LICENSE) file for details.

---

## **Contributing**
We welcome contributions! Here’s how you can help:
- **Report bugs or request features:** [Open an Issue](https://github.com/pfabrici/iceduck/issues)
- **Submit a pull request:** [Pull Requests](https://github.com/pfabrici/iceduck/pulls)

> **⭐ Support the Project**
> If you find Iceduck useful, **star this repo** and share it with others!

## **Inspirations**
Insiprations for this repo were found here :
- [IcebergLakeHouse](https://iceberglakehouse.com/)
- [Why Open Table Formats Matter (Apache Iceberg)](https://iceberg.apache.org/docs/latest/why-iceberg/)
- [Data Lakehouse vs. Data Warehouse (Databricks)](https://www.databricks.com/glossary/what-is-a-data-lakehouse)
- [Build a Data Lakehouse with Iceberg, Polaris, Trino, MinIO (Medium)](https://medium.com/@gilles.philippart/build-a-data-lakehouse-with-apache-iceberg-polaris-trino-minio-349c534ecd98)
- [Databricks Docker Spark Iceberg](https://github.com/databricks/docker-spark-iceberg/blob/main/docker-compose.yml)
- [DuckDB Postgres Extension](https://duckdb.org/docs/stable/core_extensions/postgres)
- [Apache Iceberg Documentation](https://iceberg.apache.org/docs/latest/)
- [Trino Documentation](https://trino.io/docs/current/)


---
## **Contact**
- **GitHub:** [@pfabrici](https://github.com/pfabrici)
