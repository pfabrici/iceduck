#!/bin/sh

BASE_URL="http://iceduck_polaris:${POLARIS_API_PORT}/api"
MGMT_URL="http://iceduck_polaris:${POLARIS_MGMT_PORT}"

#
#	wait max 1 Minute until Polaris is available
#
HEALTHCNT=0
while true ; do
	HEALTH=$( curl -X GET ${MGMT_URL}/q/health 2>/dev/null | jq -r ".status" )
	[ "X${HEALTH}" == "XUP" ] && break
	sleep 2
	HEALTHCNT=$(( HEALTHCNT + 1))
	[ ${HEALTHCNT} -eq 30 ] && { echo "Polaris not available"; exit 42; }
done

#
#	acquire an access token for the next steps
#
ACCESS_TOKEN=$(curl -X POST \
  ${BASE_URL}/catalog/v1/oauth/tokens \
  -d 'grant_type=client_credentials&client_id='${POLARIS_ROOT_CLIENT_ID}'&client_secret='${POLARIS_ROOT_CLIENT_SECRET}'&scope=PRINCIPAL_ROLE:ALL' \
  | jq -r '.access_token')


[ -z ${ACCESS_TOKEN} ] && exit 10

#
# Create a catalog
#
curl -i -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  ${BASE_URL}/management/v1/catalogs \
  --json '{
    "name": "'${POLARIS_CATALOG_NAME}'",
    "type": "INTERNAL",
    "properties": {
      "default-base-location": "s3://'${MINIO_BUCKETNAME}'",
      "s3.endpoint": "http://minio:9000",
      "s3.path-style-access": "true",
      "s3.access-key-id": "'${AWS_ACCESS_KEY_ID}'",
      "s3.secret-access-key": "'${AWS_SECRET_ACCESS_KEY}'",
      "s3.region": "'${AWS_REGION}'"
    },
    "storageConfigInfo": {
      "roleArn": "arn:aws:iam::000000000000:role/minio-polaris-role",
      "storageType": "S3",
      "allowedLocations": [
        "s3://'${MINIO_BUCKETNAME}'/*"
      ]
    }
  }'

# Create a catalog admin role
curl -X PUT ${BASE_URL}/management/v1/catalogs/polariscatalog/catalog-roles/catalog_admin/grants \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  --json '{"grant":{"type":"catalog", "privilege":"CATALOG_MANAGE_CONTENT"}}'

curl -X PUT ${BASE_URL}/management/v1/catalogs/polariscatalog/catalog-roles/catalog_admin/grants \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  --json '{"grant":{"type":"catalog", "privilege":"TABLE_FULL_METADATA"}}'

# Create a data engineer role
curl -X POST ${BASE_URL}/management/v1/principal-roles \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  --json '{"principalRole":{"name":"data_engineer"}}'

# Connect the roles
curl -X PUT ${BASE_URL}/management/v1/principal-roles/data_engineer/catalog-roles/polariscatalog \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  --json '{"catalogRole":{"name":"catalog_admin"}}'

# Give root the data engineer role
curl -X PUT ${BASE_URL}/management/v1/principals/root/principal-roles \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  --json '{"principalRole": {"name":"data_engineer"}}'
