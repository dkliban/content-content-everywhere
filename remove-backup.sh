podman unshare rm storage/main/varlibpulp.tar
rm /tmp/dump.sql
podman unshare rm -r storage/restore/*
pulp --profile restore rpm repository destroy --name zoo_repo
pulp --profile restore file repository destroy --name small_repo
pulp --profile restore file repository destroy --name large_repo
pulp --profile restore file distribution destroy --name large_repo
pulp --profile restore file distribution destroy --name small_repo
pulp --profile restore rpm distribution destroy --name zoo