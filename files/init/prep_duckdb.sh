#!/bin/bash

set -a
source ./etc/iceduck.env

FNAME=files/data/duckdb/workspace/init/init.sql

echo "install httpfs; load httpfs;" > $FNAME
echo "set secret_directory='secrets';" >> $FNAME
