#!/bin/bash

set -e

while ! psql -h primary -U $POSTGRES_USER -d $POSTGRES_DB -p 5432 -c "select 'it is running';" 2>&1 ; do \
	sleep 1s ; \
done

# load backup from primary instance
pg_basebackup -h primary -p 5432 -D $PGDATA -S replication_slot_slave1 --progress -X stream -U replicator -Fp -R || :

# start postgres
bash /usr/local/bin/docker-entrypoint.sh -c 'config_file=/etc/postgresql/postgresql.conf' -c 'hba_file=/etc/postgresql/pg_hba.conf'
