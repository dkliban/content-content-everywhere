set -v
#set -x
echo -e "\nhttp --auth admin:password POST http://localhost:5001/pulp/api/v3/servers/ api_root='/pulp/' base_url='http://host.containers.internal:8080' name='MainPulp' username='admin' password='password'\n"
read -p "Create an upstream Pulp server configuration in the replica Pulp."

http --auth admin:password POST http://localhost:5001/pulp/api/v3/servers/ api_root='/pulp/' base_url='http://host.containers.internal:8080' name='MainPulp' username='admin' password='password'

upstream_server_href=$(http --auth admin:password GET http://localhost:5001/pulp/api/v3/servers/ name='MainPulp' | jq -r '.results[0].pulp_href')
echo -e "\nhttp --auth admin:password POST http://localhost:5001${upstream_server_href}replicate/\n"
read -p "Make a REST API call to replicate distributions using the upstream Pulp."

http --auth admin:password POST http://localhost:5001${upstream_server_href}replicate/

replicate_task_href=$(pulp --profile replica task list --ordering -pulp_created --name pulp_replica.app.tasks.replication.replicate_distributions | jq -r '.[0].pulp_href')
replicate_task_group_href=$(pulp --profile replica task list --ordering -pulp_created --name pulp_replica.app.tasks.replication.replicate_distributions | jq -r '.[0].task_group')

echo -e "\npulp --profile replica task show --href $replicate_task_href\n"
read -p "Check the status of initial task."

pulp --profile replica task show --href $replicate_task_href

echo -e "\npulp --profile replica task-group show --href $replicate_task_group_href\n"
read -p "Check the status of the whole task group."
pulp --profile replica task-group show --href $replicate_task_group_href