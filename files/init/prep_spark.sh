#!/bin/bash

set -a
source ./etc/iceduck.env

FNAME=files/data/spark/config/spark-defaults.conf

echo "spark.sql.extensions                   org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions" > $FNAME
echo "spark.sql.catalog.default                 org.apache.iceberg.spark.SparkCatalog" >> $FNAME
echo "spark.sql.catalog.default.type            rest" >> $FNAME
echo "spark.sql.catalog.default.uri             http://rest:8181/api/catalog/" >> $FNAME
echo "spark.sql.catalog.default.io-impl         org.apache.iceberg.aws.s3.S3FileIO" >> $FNAME
echo "spark.sql.catalog.default.warehouse       ${POLARIS_CATALOG_NAME}" >> $FNAME
echo "spark.sql.catalog.default.s3.endpoint     http://minio:9000" >> $FNAME
echo "spark.sql.catalog.default.rest.auth.type  oauth2" >> $FNAME
echo "spark.sql.catalog.default.oauth2-server-uri http://rest:8181/api/catalog/v1/oauth/tokens" >> $FNAME
echo "spark.sql.catalog.default.credential      ${POLARIS_ROOT_CLIENT_ID}:${POLARIS_ROOT_CLIENT_SECRET}" >> $FNAME
echo "spark.sql.catalog.default.scope           PRINCIPAL_ROLE:ALL" >> $FNAME
echo "spark.sql.defaultCatalog               default" >> $FNAME
echo "spark.eventLog.enabled                 true" >> $FNAME
echo "spark.eventLog.dir                     /home/iceberg/spark-events" >> $FNAME
echo "spark.history.fs.logDirectory          /home/iceberg/spark-events" >> $FNAME
echo "spark.sql.catalogImplementation        in-memory" >> $FNAME


FNAME=files/data/spark/config/pyiceberg.yaml

echo "catalog:" > $FNAME
echo "  default:" >> $FNAME
echo "      type: rest" >> $FNAME
echo "      uri: http://rest:8181/api/catalog/" >> $FNAME
echo "      header.X-Iceberg-Access-Delegation: vended-credentials" >> $FNAME
echo "      credential: ${POLARIS_ROOT_CLIENT_ID}:${POLARIS_ROOT_CLIENT_SECRET}" >> $FNAME
echo "      warehouse: ${POLARIS_CATALOG_NAME}" >> $FNAME
echo "      scope: PRINCIPAL_ROLE:ALL" >> $FNAME
echo "      token-refresh-enabled: true" >> $FNAME
echo "      py-io-impl: pyiceberg.io.fsspec.FsspecFileIO" >> $FNAME
echo "      s3.endpoint: http://minio:9000" >> $FNAME
echo "      s3.access-key-id: ${AWS_ACCESS_KEY_ID}" >> $FNAME
echo "      s3.secret-access-key: ${AWS_SECRET_ACCESS_KEY}" >> $FNAME