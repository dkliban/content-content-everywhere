set +v

echo -e "\npodman-compose exec pulp-main tar cfv varlibpulp.tar -C /var/lib/pulp .\n"
read -p "Create an archive from /var/lib/pulp/."

podman-compose exec pulp-main tar cfv varlibpulp.tar -C /var/lib/pulp .

echo -e "\npodman-compose exec pulp-main cp varlibpulp.tar /var/lib/pulp/varlibpulp.tar\n"
read -p "Copy the archive to where I can access it on the host."

podman-compose exec pulp-main cp varlibpulp.tar /var/lib/pulp/varlibpulp.tar

echo -e "\npodman unshare tar -xvf ./storage/main/varlibpulp.tar -C ./storage/restore/\n"
read -p "Extract the archive into /var/lib/pulp of the restored Pulp."

podman unshare tar -xvf ./storage/main/varlibpulp.tar -C./storage/restore/

echo -e "\npodman-compose exec sudo -u postgres pulp-main pg_dumpall > /tmp/dump.sql\n"
read -p "Dump the postgresql database to a file."

podman-compose exec pulp-main sudo -u postgres pg_dumpall > /tmp/dump.sql

echo -e "\npodman unshare cp /tmp/dump.sql ./storage/restore/\n"
read -p "Copy the database dump to the storage of restored Pulp."

podman unshare cp /tmp/dump.sql ./storage/restore/

echo -e "\npodman unshare cp ./restore-db.sh storage/restore/restore.sh\n"
read -p "Copy the restore-db.sh script to the restored Pulp's storage."

podman unshare cp ./restore-db.sh storage/restore/restore.sh

echo -e "\npodman-compose run pulp-restore bash\n"
read -p "Run pulp-restore container without starting services."

podman-compose run pulp-restore bash

echo -e "\npodman container stop content-content-everywhere_pulp-restore_1\n"
read -p "Ensure that the container is stopped."

podman container stop content-content-everywhere_pulp-restore_1

echo -e "\npodman container rm content-content-everywhere_pulp-restore_1\n"
read -p "Remove the container. But keep the volumes for storage and Postgres."
podman container rm content-content-everywhere_pulp-restore_1

podman-compose up -d