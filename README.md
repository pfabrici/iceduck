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

## 📌 **What is Iceduck?**
**Iceduck** is an **open-source Data Lakehouse stack** designed for **learning, prototyping, and testing** modern data architectures **locally**—without cloud dependencies or proprietary SaaS solutions.

It provides a **Docker Compose-based environment** with:
- **MinIO** as the underlying **S3-compatible object storage**
- **Apache Polaris** as a **REST catalog for Apache Iceberg**
- **Trino** as a **distributed SQL query engine** (accessing Iceberg, Postgres, and more)
- **Postgres** as the **metastore for Polaris** and a traditional relational store
- **Spark** as a **distributed query and processing platform**
- **DuckDB** for **fast analytical queries** on Iceberg tables
- **Jupyter Notebooks** for **interactive exploration** with Spark and Python

> **💡 Why "Iceduck"?**
> The project started as an exploration of **DuckDB + Apache Iceberg** capabilities. Along the way, Trino, Spark, Jupyter, and other tools were added—but the name stuck!

---

## 🔥 **Why Use Iceduck?**
Data Lakes and Data Lakehouses are **replacing traditional data warehouses** for modern analytics, but most infrastructure solutions are **proprietary or cloud-locked** (e.g., Databricks, Snowflake, or AWS/GCP services). This makes it **difficult to learn the core open-source technologies** behind these systems—such as **Apache Iceberg, Trino, or MinIO**—without vendor dependencies.

### **Key Challenges Addressed by Iceduck:**
| Problem | Solution |
|---------|----------|
| **Cost Barriers** | Runs **locally at zero cost** (no cloud fees) |
| **Vendor Lock-in** | Uses **open standards** (Apache Iceberg, REST catalogs) |
| **Learning Curve** | **Full control** over configurations and integrations |
| **Innovation Speed** | Test **bleeding-edge features** without waiting for cloud providers |

> *"Iceduck lets you explore Data Lakehouse concepts **without the cloud complexity**—perfect for developers, data engineers, and curious learners."*

**📚 Learn More:**
- [Why Open Table Formats Matter (Apache Iceberg)](https://iceberg.apache.org/docs/latest/why-iceberg/)
- [Data Lakehouse vs. Data Warehouse (Databricks)](https://www.databricks.com/glossary/what-is-a-data-lakehouse)
- [Build a Data Lakehouse with Iceberg, Polaris, Trino, MinIO (Medium)](https://medium.com/@gilles.philippart/build-a-data-lakehouse-with-apache-iceberg-polaris-trino-minio-349c534ecd98)

---

## 🚀 **Quickstart**
Iceduck is designed to be **as easy as running a single script**. Here’s how to get started:

### **Prerequisites**
- **Docker** + **Docker Compose** (tested with Docker 24+ and Compose v2+)
- **Linux/Unix environment** (wrapper scripts are Bash-based)
- **Git** (to clone the repository)

### **1. Clone the Repository**
```bash
git clone https://github.com/pfabrici/iceduck.git
cd iceduck
```

### **2. Initialize and Start the Stack**
```bash
./iceduck init   # Prepares configs and starts the stack (first time only)
./iceduck start  # Starts the stack (equivalent to `docker compose up -d`)
```

### **3. Stop or Clean Up**
```bash
./iceduck stop    # Stops the stack (equivalent to `docker compose down`)
./iceduck clean   # Stops the stack AND removes all runtime data
```

> **⚠️ Note:** All wrapper scripts must be run from the **main folder** of the repo.

---

## 🔌 **Accessing Services**
Once the stack is running, you can access the following services:

| Service | URL | Credentials | Wrapper Script |
|---------|-----|-------------|----------------|
| **MinIO Web UI** | [http://localhost:9001](http://localhost:9001) | `admin` / `password` | `bin/mc` |
| **Trino Web UI** | [http://localhost:8060](http://localhost:8060) | - | `bin/trino` |
| **Jupyter Notebooks** | [http://localhost:8888](http://localhost:8888) | - | - |
| **Spark UI** | [http://localhost:8080](http://localhost:8080) | - | - |
| **Postgres** | `localhost:5432` | `postgres` / `password` | `bin/psql` |
| **Polaris Admin** | - | - | `bin/iceshell`, `bin/poladm` |

### **MinIO**
- **Manage buckets and objects** using the `mc` CLI tool:
  ```bash
  bin/mc ls minio/warehouse  # List buckets
  ```
- **Web UI:** [http://localhost:9001](http://localhost:9001) (Default credentials: `admin` / `password`)

### **Trino**
- **Run SQL queries** against Iceberg, Postgres, and other catalogs:
  ```bash
  bin/trino
  ```
  Example:
  ```sql
  SHOW CATALOGS;  -- Lists available catalogs (e.g., `warehouse`, `pgice`)
  ```

### **Postgres**
- **Connect via `psql`**:
  ```bash
  bin/psql
  ```
- **JDBC URL:** `jdbc:postgresql://localhost:5432/postgres`

### **Spark & Jupyter**
- **Jupyter Notebooks:** [http://localhost:8888](http://localhost:8888)
- **Spark UI:** [http://localhost:8080](http://localhost:8080) (Monitor running Spark jobs)

### **Polaris (Iceberg Catalog)**
- **Manage catalogs and permissions** via API or CLI:
  ```bash
  bin/iceshell  # Shell with curl and environment variables
  bin/poladm   # Polaris admin tools (e.g., for bootstrapping)
  ```

---

## 📂 **Project Structure**
```
iceduck/
├── bin/               # Wrapper scripts (mc, trino, psql, iceshell, poladm)
├── etc/               # Configuration files (e.g., iceduck.env)
├── files/             # Additional files (e.g., Spark configs)
├── docker-compose.yaml # Docker Compose setup
├── iceduck            # Main wrapper script (start/stop/clean/init)
├── LICENSE            # Apache 2.0 License
└── README.md          # This file
```

---

## 📜 **License**
This project is licensed under the **Apache License 2.0** – see the [LICENSE](LICENSE) file for details.

---

## 🤝 **Contributing**
We welcome contributions! Here’s how you can help:
- **Report bugs or request features:** [Open an Issue](https://github.com/pfabrici/iceduck/issues)
- **Submit a pull request:** [Pull Requests](https://github.com/pfabrici/iceduck/pulls)

> **⭐ Support the Project**
> If you find Iceduck useful, **star this repo** and share it with others!

---
## 📚 **References & Inspirations**
- [Build a Data Lakehouse with Apache Iceberg, Polaris, Trino, MinIO (Medium)](https://medium.com/@gilles.philippart/build-a-data-lakehouse-with-apache-iceberg-polaris-trino-minio-349c534ecd98)
- [Databricks Docker Spark Iceberg](https://github.com/databricks/docker-spark-iceberg/blob/main/docker-compose.yml)
- [DuckDB Postgres Extension](https://duckdb.org/docs/stable/core_extensions/postgres)
- [Apache Iceberg Documentation](https://iceberg.apache.org/docs/latest/)
- [Trino Documentation](https://trino.io/docs/current/)

---
## 📧 **Contact**
- **GitHub:** [@pfabrici](https://github.com/pfabrici)
