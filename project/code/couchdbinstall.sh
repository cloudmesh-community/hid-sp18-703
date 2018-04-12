# bash script to install and configure couchdb cluster

# tracking the time taken for couchdb installation and configuration
SECONDS=0
cluster_setup_val=$1
replica_val=$2
shard_val=$3
rm ./couchdbansible/roles/couchdb/vars/main.yml
echo "---" > ./couchdbansible/roles/couchdb/vars/main.yml
echo "nodes_number: 2" >> ./couchdbansible/roles/couchdb/vars/main.yml
echo "cluster_setup: $cluster_setup_val" >> ./couchdbansible/roles/couchdb/vars/main.yml
echo "replica: $replica_val" >> ./couchdbansible/roles/couchdb/vars/main.yml
echo "shard: $shard_val" >> ./couchdbansible/roles/couchdb/vars/main.yml


ansible-playbook -e 'host_key_checking=False' -i ./couchdbansible/inventory.txt ./couchdbansible/playbook.yml

duration=$SECONDS
echo "CouchDBInstall_time" > ./CouchDBBenchmark/couchDBInstallDuration.csv
echo "$duration" >> ./CouchDBBenchmark/couchDBInstallDuration.csv
