# Cleanup main pulp

pulp rpm distribution destroy --name zoo
pulp rpm repository destroy --name zoo_repo
pulp rpm remote destroy --name zoo_remote

pulp file distribution destroy --name small_repo
pulp file repository destroy --name small_repo
pulp file remote destroy --name small_repo_remote

pulp file distribution destroy --name large_repo
pulp file repository destroy --name large_repo
pulp file remote destroy --name large_repo_remote

