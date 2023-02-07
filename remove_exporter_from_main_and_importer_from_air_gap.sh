podman unshare rm -r storage/main/exports

pulp exporter pulp destroy --name my_exporter

podman unshare rm -r storage/air-gap/exports

# remove the importer
pulp --profile air-gap importer pulp destroy --name my_importer

# remove the repositories
pulp --profile air-gap file repository destroy --name small_repo
pulp --profile air-gap file repository destroy --name large_repo
pulp --profile air-gap rpm repository destroy --name zoo_repo

# remove the distributions
pulp --profile air-gap file distribution destroy --name small_repo
pulp --profile air-gap file distribution destroy --name large_repo
pulp --profile air-gap rpm distribution destroy --name zoo_repo