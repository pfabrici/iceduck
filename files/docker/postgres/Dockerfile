FROM postgres:17.7-bookworm

RUN set -eux; \
	apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates curl gnupg lsb-release build-essential git cmake make pkg-config gosu \
		liblz4-dev postgresql-server-dev-17 ninja-build libssl-dev libcurl4-openssl-dev; \
	git config --global http.sslVerify false; \
	git clone --depth 1 https://github.com/duckdb/pg_duckdb.git /tmp/pg_duckdb; \
	make -C /tmp/pg_duckdb install && rm -rf /tmp/pg_duckdb ;  \
	apt-get remove -y --purge curl build-essential git cmake make gosu postgresql-server-dev-17 ninja-build; \
	apt-get autoremove -y
	
RUN echo "shared_preload_libraries = 'pg_duckdb'" >> /usr/share/postgresql/postgresql.conf.sample




