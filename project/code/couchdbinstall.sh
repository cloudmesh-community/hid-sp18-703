# bash script to install and configure couchdb cluster

# tracking the time taken for couchdb installation and configuration
SECONDS=0 
ansible-playbook -e 'host_key_checking=False' -i ./couchdbansible/inventory.txt ./couchdbansible/playbook.yml
duration=$SECONDS
echo "$duration" > couchDBInstallDuration.csv
