# bash script to copy json file to remote server and load to couchdb and perform get query


line=$(sed -n '2p' ./couchdbansible/inventory.txt)
ip=$(echo $line | head -n1 | awk '{print $1;}')

#copying python code that creates the json data to remote server
scp ./csv_to_json.py cc@$ip:/home/cc
ssh cc@$ip 'sudo python csv_to_json.py' # run python script to create json file

# tracking the time taken for writing data in couchdb
echo  "Starting bulk load json file into couchDB"
start=`date +%s`

ssh cc@$ip 'curl -X POST -H "Content-Type: application/json" --data-binary @/home/cc/winedata.json http://admin:password@127.0.0.1:5984/test/_bulk_docs' > ./logs/output.txt
end=`date +%s`
runtime=$((end-start))

echo "bulkloadtime" > ./CouchDBBenchmark/couchDBWriteJson.csv
echo "$runtime" >> ./CouchDBBenchmark/couchDBWriteJson.csv

echo "finished loading json file into couchDB"

echo  "Starting finding document in couchDB"
start=`date +%s`
ssh cc@$ip 'curl -X POST -H "Content-Type: application/json"  http://admin:password@127.0.0.1:5984/test/_find -d '\''{"selector": {"quality": {"$gt": 6}},"fields": ["_id", "_rev", "quality"],"skip": 0,"execution_stats": true}'\''' > ./logs/output.txt
end=`date +%s`
runtime=$((end-start))
echo "finddocumenttime" > ./CouchDBBenchmark/couchDBFindJson.csv
echo "$runtime" >> ./CouchDBBenchmark/couchDBFindJson.csv
echo "finished find document from couchDB "

#copying file to  remote server for view in couchdb
scp ./mapreducefun.js cc@$ip:/home/cc

echo  "Starting mapreduce view on couchDB"
start=`date +%s`
ssh cc@$ip 'curl -X PUT http://admin:password@127.0.0.1:5984/test/_design/qualitymap -d @/home/cc/mapreducefun.js' > ./logs/output.txt

#to get the total number of records where quality is greater than 5 
ssh cc@$ip 'curl -X GET http://admin:password@127.0.0.1:5984/test/_design/qualitymap/_view/qualityTotal' > ./logs/output.txt

end=`date +%s`
runtime=$((end-start))
echo "Mapreducettime" > ./CouchDBBenchmark/couchDBMapJson.csv
echo "$runtime" >> ./CouchDBBenchmark/couchDBMapJson.csv
echo "finished mapreduce view couchDB"


paste -d, ./CouchDBBenchmark/couchDBWriteJson.csv ./CouchDBBenchmark/couchDBFindJson.csv > ./CouchDBBenchmark/temp1.csv
paste -d, ./CouchDBBenchmark/temp1.csv ./CouchDBBenchmark/couchDBMapJson.csv > ./CouchDBBenchmark/temp2.csv
paste -d, ./CouchDBBenchmark/couchDBInstall.csv ./CouchDBBenchmark/temp2.csv > ./CouchDBBenchmark/benchmark_$(date +'%d%m%Y%H%M').csv

