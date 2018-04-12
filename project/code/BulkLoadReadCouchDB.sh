# bash script to copy json file to remote server and load to couchdb and perform get query


line=$(sed -n '2p' ./couchdbansible/inventory.txt)
#ip="${line:0:14}"
ip=$(echo $line | head -n1 | awk '{print $1;}')



# tracking the time taken for writing data in couchdb
echo  "Starting bulk load json file into couchDB"
SECONDS=0 
scp ./winedata.json cc@$ip:/home/cc

ssh cc@$ip 'curl -X POST -H "Content-Type: application/json" --data-binary @/home/cc/winedata.json http://admin:password@127.0.0.1:5984/test/_bulk_docs'
duration=$SECONDS
echo "bulkloadtime" > couchDBWriteJson.csv
echo "$duration" >> couchDBWriteJson.csv

echo "the time taken to load json file into couchDB is $duration seconds"

echo  "Starting finding document in couchDB"
SECONDS=0 
ssh cc@$ip 'curl -X POST -H "Content-Type: application/json"  http://admin:password@127.0.0.1:5984/test/_find -d '\''{"selector": {"quality": {"$gt": 6}},"fields": ["_id", "_rev", "quality"],"skip": 0,"execution_stats": true}'\'''
duration_find=$SECONDS
echo "finddocumenttime" > couchDBFindJson.csv
echo "$duration_find" >> couchDBFindJson.csv
echo "the time taken to find document in couchDB is $duration_find seconds"

paste -d, couchDBWriteJson.csv couchDBFindJson.csv > ./CouchDBBenchmark/benchmark_$(date +'%d%m%Y%H%M').csv

