set +v

echo -e "\npulp exporter pulp create --name my_exporter --path /var/lib/pulp/exports --repository file:file:small_repo --repository file:file:large_repo --repository rpm:rpm:zoo_repo\n"
read -p "Create an exporter that will export 3 repositories."

pulp exporter pulp create --name my_exporter --path /var/lib/pulp/exports --repository file:file:small_repo --repository file:file:large_repo --repository rpm:rpm:zoo_repo

echo -e "\npulp export pulp run --exporter my_exporter\n"
read -p "Run the exporter to create an export"

pulp export pulp run --exporter my_exporter

echo -e "\npodman unshare cp -r storage/main/exports storage/air-gap/exports\n"
read -p "Transfer the export to the air-gapped Pulp."

podman unshare cp -r storage/main/exports storage/air-gap/exports

echo -e "\npulp --profile air-gap importer pulp create --name my_importer\n"
read -p "Create an importer on the air-gapped Pulp."

pulp --profile air-gap importer pulp create --name my_importer

echo -e "\npulp --profile air-gap file repository create --name small_repo --autopublish\n"
read -p "Create the small_repo on the air-gapped Pulp."

pulp --profile air-gap file repository create --name small_repo --autopublish

echo -e "\npulp --profile air-gap repository create --name large_repo --autopublish\n"
read -p "Create the large_repo on the air-gapped Pulp."

pulp --profile air-gap file repository create --name large_repo --autopublish

echo -e "\npulp --profile air-gap rpm repository create --name zoo_repo --autopublish\n"
read -p "Create the zoo_repo on the air-gapped Pulp."

pulp --profile air-gap rpm repository create --name zoo_repo --autopublish

importer_href=$(pulp --profile air-gap importer pulp list | jq -r '.[0].pulp_href')

export_name=$(ls -la storage/air-gap/exports/ | awk '{print $9}' | grep tar)
export_toc=$(ls -la storage/air-gap/exports/ | awk '{print $9}' | grep toc)

echo -e "\nhttp --auth admin:password POST http://localhost:8081${importer_href}imports/ toc=/var/lib/pulp/exports/$export_toc create_repositories=true\n"
read -p "Import the export by specifying the path to the archive and the table of contents."

http --auth admin:password POST http://localhost:8081${importer_href}imports/ toc=/var/lib/pulp/exports/$export_toc create_repositories=true

task_group_href=$(pulp --profile air-gap task list --name pulpcore.app.tasks.importer.pulp_import --ordering -pulp_created | jq -r '.[0].task_group')

echo -e "\npulp task-group show --href ${task_group_href}\n"
read -p "Let's check the state of the task group created to perform the import."

pulp --profile air-gap task-group show --href ${task_group_href}

echo -e "\npulp --profile air-gap file distribution create --name small_repo --repository small_repo\n"
read -p "Create a distribution for the small_repo."

pulp --profile air-gap file distribution create --name small_repo --repository small_repo --base-path files/small_repo

echo -e "\npulp --profile air-gap file distribution create --name large_repo --repository large_repo\n"
read -p "Create a distribution for the large_repo."

pulp --profile air-gap file distribution create --name large_repo --repository large_repo --base-path files/large_repo

echo -e "\npulp --profile air-gap rpm distribution create --name zoo_repo --repository zoo_repo --base-path rpm/zoo\n"
read -p "Create a distribution for the large_repo."

pulp --profile air-gap rpm distribution create --name zoo_repo --repository zoo_repo --base-path rpm/zoo

