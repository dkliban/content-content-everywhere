# Cleanup replica

pulp --profile replica file distribution destroy --name small_repo
pulp --profile replica file repository destroy --name small_repo
pulp --profile replica file remote destroy --name small_repo

pulp --profile replica file distribution destroy --name large_repo
pulp --profile replica file repository destroy --name large_repo
pulp --profile replica file remote destroy --name large_repo

pulp --profile replica rpm distribution destroy --name zoo
pulp --profile replica rpm repository destroy --name zoo
pulp --profile replica rpm remote destroy --name zoo

# Remove Upstream Server config

upstream_server_href=$(http --auth admin:password GET http://localhost:5001/pulp/api/v3/servers/ name='MainPulp' | jq -r '.results[0].pulp_href')
http --auth admin:password DELETE http://localhost:5001${upstream_server_href}