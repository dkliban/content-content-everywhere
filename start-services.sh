podman-compose up -d
sleep 30
podman-compose exec pulp-main pulpcore-manager reset-admin-password --password password
podman-compose exec pulp-restore pulpcore-manager reset-admin-password --password password
podman-compose exec pulp-air-gap pulpcore-manager reset-admin-password --password password