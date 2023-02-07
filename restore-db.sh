set +v

echo -e "\nrm -rf /var/lib/pgsql/data\n"
read -p "Cleanup the postgres data directory."

rm -rf /var/lib/pgsql/data

echo -e "\nsu postgres -c \"initdb -E UTF8 --locale=C.UTF-8 --pgdata=/var/lib/pgsql/data\"\n"
read -p "Initialize the data directory for Postgres."

su postgres -c "initdb -E UTF8 --locale=C.UTF-8 --pgdata=/var/lib/pgsql/data"

echo -e "\nsu postgres -c \"pg_ctl start -D /var/lib/pgsql/data\"\n"
read -p "Start postgres"

su postgres -c "pg_ctl start -D /var/lib/pgsql/data"

head -n -4 /var/lib/pulp/dump.sql  > tempfile && mv -f tempfile /var/lib/pulp/dump.sql

echo -e "\nsu postgres -c \"psql -d postgres -f /var/lib/pulp/dump.sql\"\n"
read -p "Restore the database."

su postgres -c "psql -d postgres -f /var/lib/pulp/dump.sql"
