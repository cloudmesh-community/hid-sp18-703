Project Code Execution
=============

All the codes for this project are under project-code
directory. There are three directories under project-code.

  * CouchDBBenchmark which contains CSV files from deployment and
    benchmarking processes.  
  * couchdbansible which contains Ansible scripts logs which contains console output logs


 Before starting the deployment of CouchDB, user have to
perform the following preparation steps.

 * Start two Instances in Chameleon Cloud with the specification
 * Allocate floating IPs to the instance created
 * Add  security rules as mentioned under Security section
      of this report to the two instances 
 * User has to manually insert the IP addresses by modifying
      inventory.txt file which is found under project-code
      /couchdbansible directory. There are two hosts 
      defined under inventory.txt. One of the IP addresses
      goes under [couchdb_Coordination_host] section of inventory.txt
      and the second IP address goes under [couchdb_hosts].
      
Deploy CouchDB
=============

To deploy CouchDB, on command prompt cd to project-code/ directory and run
couchdbinstall.sh as providing three parameters. 

  * First parameter takes true or false to indicate whether to
    install CouchDB in single node or cluster
  * Second parameter is an integer number for the value of
      replica
  * Third parameter is an integer number for the value of
      shard

An example command

./couchdbinstall.sh true 3 8 


Benchmark Tests
=============

To run benchmark tests, on command prompt cd to project-code/ directory and run

./BulkLoadReadCouchDB.sh

This script performs different benchmark tests and saves all the time
durations into CSV file name starting with benchmark_under
CouchDBBenchmark directory.

Combining CSV files
=============

To combine all CSV files from benchmarking tests into one file named CouchDBfinal.csv run

./CombineBenchmark.sh 

A copy of this file is also saved under project-artifact if needed in
the future to reproduce the graphs in this project


Plotting graphs for Benchmark Tests
=============

To Plot the graphs for benchmarking analysis run the 
plotBenchmark.py script from command line as follows

python plotBenchmark.py




