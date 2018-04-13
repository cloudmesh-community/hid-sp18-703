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

echo "finished loading json file into couchDB"

echo  "Starting finding document in couchDB"
SECONDS=0 
ssh cc@$ip 'curl -X POST -H "Content-Type: application/json"  http://admin:password@127.0.0.1:5984/test/_find -d '\''{"selector": {"quality": {"$gt": 6}},"fields": ["_id", "_rev", "quality"],"skip": 0,"execution_stats": true}'\'''
duration_find=$SECONDS
echo "finddocumenttime" > couchDBFindJson.csv
echo "$duration_find" >> couchDBFindJson.csv
echo "finished find document from couchDB "

#copying file to  remote server for view in couchdb
scp ./mapreducefun.js cc@$ip:/home/cc

echo  "Starting mapreduce view on couchDB"
SECONDS=0
ssh cc@$ip 'curl -X PUT http://admin:password@127.0.0.1:5984/test/_design/qualitymap -d @/home/cc/mapreducefun.js'

#to get the total number of records where quality is greater than 5 
ssh cc@$ip 'curl -X GET http://admin:password@127.0.0.1:5984/test/_design/qualitymap/_view/qualityTotal'

duration_find=$SECONDS
echo "Mapreducettime" > couchDBMapJson.csv
echo "$duration_map" >> couchDBMapJson.csv
echo "finished mapreduce view couchDB"



paste -d, couchDBWriteJson.csv couchDBFindJson.csv > ./CouchDBBenchmark/benchmark_$(date +'%d%m%Y%H%M').csv

