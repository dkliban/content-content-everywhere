pulp file remote create --name small_repo_remote --url http://host.containers.internal:8083/file/PULP_MANIFEST
pulp file repository create --name small_repo --remote small_repo_remote  --autopublish
pulp file distribution create --name small_repo --repository small_repo --base-path files/small_repo
pulp file repository sync --name small_repo

pulp file remote create --name large_repo_remote --url http://host.containers.internal:8083/file-large/PULP_MANIFEST
pulp file repository create --name large_repo --remote large_repo_remote --autopublish
pulp file distribution create --name large_repo --repository large_repo --base-path files/large_repo
pulp file repository sync --name large_repo


pulp rpm remote create --name zoo_remote --url http://host.containers.internal:8083/rpm-unsigned/
pulp rpm repository create --name zoo_repo --remote zoo_remote  --autopublish
pulp rpm distribution create --name zoo --repository zoo_repo --base-path rpm/zoo
pulp rpm repository sync --name zoo_repo