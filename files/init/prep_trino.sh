#!/bin/bash

set -a
source ./etc/iceduck.env

FNAME=files/data/trino/etc/catalog/warehouse.properties

echo "connector.name=iceberg" > $FNAME
echo "iceberg.catalog.type=rest" >> $FNAME
echo "iceberg.rest-catalog.uri=http://polaris:8181/api/catalog/" >> $FNAME
echo "iceberg.rest-catalog.warehouse=${POLARIS_CATALOG_NAME}" >> $FNAME
echo "iceberg.rest-catalog.vended-credentials-enabled=true" >> $FNAME
echo "iceberg.rest-catalog.security=OAUTH2" >> $FNAME
echo "iceberg.rest-catalog.oauth2.credential=${POLARIS_ROOT_CLIENT_ID}:${POLARIS_ROOT_CLIENT_SECRET}" >> $FNAME
echo "iceberg.rest-catalog.oauth2.scope=PRINCIPAL_ROLE:ALL" >> $FNAME
echo "" >> $FNAME
echo "# required for Trino to read from/write to S3" >> $FNAME
echo "fs.native-s3.enabled=true" >> $FNAME
echo "s3.endpoint=http://minio:9000" >> $FNAME
echo "s3.region=${AWS_REGION}" >> $FNAME

FNAME=files/data/trino/etc/catalog/pgice.properties

echo "connector.name=postgresql" > $FNAME
echo "connection-url=jdbc:postgresql://iceduck_db:5432/${ICEDUCK_DB_NAME}" >> $FNAME
echo "connection-user=${ICEDUCK_DB_USER}" >> $FNAME
echo "connection-password=${ICEDUCK_DB_PASSWORD}" >> $FNAME


FNAME=files/data/trino/etc/config.properties
echo "coordinator=true" > $FNAME
echo "node-scheduler.include-coordinator=true" >> $FNAME
echo "http-server.http.port=8080" >> $FNAME
echo "discovery.uri=http://trino-coordinator:8080" >> $FNAME

FNAME=files/data/trino/etc/jvm.config

cat > $FNAME <<EOF
-server
-Xmx16G
-XX:InitialRAMPercentage=80
-XX:MaxRAMPercentage=80
-XX:G1HeapRegionSize=32M
-XX:+ExplicitGCInvokesConcurrent
-XX:+ExitOnOutOfMemoryError
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-XX:ReservedCodeCacheSize=512M
-XX:PerMethodRecompilationCutoff=10000
-XX:PerBytecodeRecompilationCutoff=10000
-Djdk.attach.allowAttachSelf=true
-Djdk.nio.maxCachedBufferSize=2000000
-Dfile.encoding=UTF-8
# Allow loading dynamic agent used by JOL
-XX:+EnableDynamicAgentLoading
EOF


FNAME=files/data/trino/etc/node.properties

echo "node.environment=production" > $FNAME
echo "node.id=ffffffff-ffff-ffff-ffff-ffffffffffff" >> $FNAME
echo "node.data-dir=/data" >> $FNAME