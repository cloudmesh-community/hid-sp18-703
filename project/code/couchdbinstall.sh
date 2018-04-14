# bash script to install and configure couchdb cluster

# tracking the time taken for couchdb installation and configuration
start=`date +%s`
cluster_setup_val=$1
replica_val=$2
shard_val=$3
rm ./couchdbansible/roles/couchdb/vars/main.yml
echo "---" > ./couchdbansible/roles/couchdb/vars/main.yml
echo "nodes_number: 2" >> ./couchdbansible/roles/couchdb/vars/main.yml
echo "cluster_setup: $cluster_setup_val" >> ./couchdbansible/roles/couchdb/vars/main.yml
echo "replica: $replica_val" >> ./couchdbansible/roles/couchdb/vars/main.yml
echo "shard: $shard_val" >> ./couchdbansible/roles/couchdb/vars/main.yml


ansible-playbook -e 'host_key_checking=False' -i ./couchdbansible/inventory.txt ./couchdbansible/playbook.yml > ./logs/output.txt

end=`date +%s`
runtime=$((end-start))
echo "CouchDBInstall_time" > ./CouchDBBenchmark/couchDBInstallDuration.csv
echo "$runtime" >> ./CouchDBBenchmark/couchDBInstallDuration.csv
echo "Cluster_Setup" > ./CouchDBBenchmark/couchDBClusterSetup.csv
echo "$cluster_setup_val" >> ./CouchDBBenchmark/couchDBClusterSetup.csv
echo "replica_val" > ./CouchDBBenchmark/couchDBreplica.csv
echo "$replica_val" >> ./CouchDBBenchmark/couchDBreplica.csv
echo "shard_val" > ./CouchDBBenchmark/couchDBshard.csv
echo "$shard_val" >> ./CouchDBBenchmark/couchDBshard.csv



paste -d, ./CouchDBBenchmark/couchDBClusterSetup.csv ./CouchDBBenchmark/couchDBreplica.csv > ./CouchDBBenchmark/temp1.csv
paste -d, ./CouchDBBenchmark/temp1.csv ./CouchDBBenchmark/couchDBshard.csv > ./CouchDBBenchmark/temp2.csv
paste -d, ./CouchDBBenchmark/temp2.csv ./CouchDBBenchmark/couchDBInstallDuration.csv  >  ./CouchDBBenchmark/couchDBInstall.csv

