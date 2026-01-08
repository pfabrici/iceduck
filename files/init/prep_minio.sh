mc alias set minio http://minio:9000 ${MINIO_ROOT_USER} ${MINIO_ROOT_PASSWORD}
mc mb minio/${MINIO_BUCKETNAME}
mc anonymous set public minio/${MINIO_BUCKETNAME}
