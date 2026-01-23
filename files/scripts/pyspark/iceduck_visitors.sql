from pyiceberg.catalog import load_catalog
from pyiceberg.io.fsspec import FsspecFileIO
from pyiceberg.exceptions import NamespaceAlreadyExistsError

cat = load_catalog("default")

# show existing namespaces and tables
for ns in cat.list_namespaces():
    print(ns)
    print(cat.list_tables(ns))

try:
    cat.create_namespace("iceduck")
except NamespaceAlreadyExistsError:
    print("Namespace iceduck does already exist.")

from pyiceberg.schema import Schema
from pyiceberg.types import NestedField, IntegerType, StringType, FloatType, TimestampType

schema = Schema(
    NestedField(field_id=1, name="visit_timestamp", field_type=TimestampType(), required=True),
    NestedField(field_id=2, name="visitor", field_type=StringType(), required=True),
    NestedField(field_id=3, name="description", field_type=StringType(), required=True),
)

iceberg_table = cat.create_table_if_not_exists(
    identifier='iceduck.visitors',
    schema=schema
)

print(iceberg_table.schema())    

import pyarrow as pa
import datetime

pa_table_data = pa.Table.from_pylist([
    {'visit_timestamp': datetime.datetime.now().timestamp() , 'visitor': 'PyIceberg', 'description': 'created with PyIceberg and the CLI :-)'},
], schema=iceberg_table.schema().as_arrow())

try:
    iceberg_table.append(df=pa_table_data)
except:
    print("Didn't work")    