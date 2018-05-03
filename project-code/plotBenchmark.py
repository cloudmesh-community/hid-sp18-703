# python script to plot benchamarking results
# Author: Ribka Rufael
import pandas 
import matplotlib.pyplot as plt

# function for plotting the graphs
def plotbench(df1,df2,xlbl,fName):
    
    plt.plot(df1,df2)
    plt.ylim(ymin=0)
    plt.ylabel('Time in Seconds')
    plt.xlabel(xlbl)
    plt.legend()
    
    plt.savefig('../images/' + fName)
    plt.show()
    
    
  
# load the couchDBfinal.csv file which contains all the bechmark results into dataframe 
df = pandas.read_csv("./CouchDBBenchmark/couchDBfinal.csv")

"""### Plots for analysing impact of Shards on bulkload, find and mapreduce"""
# selecting values from data frame where we have fixed value for replica_val == 3
df_shard = df[df.replica_val == 3]
df_shard = df_shard.sort_values(by='shard_val', ascending=1)

# plot the line graph for shards vs bulkloadtime
xlbl = 'Number of Shards'
fName = 'ShardsBulkLoad.pdf'
plotbench(df_shard['shard_val'],df_shard['bulkloadtime'],xlbl, fName)

# plot the line graph for shards vs find document time
fName = 'ShardsFindDoc.pdf'
plotbench(df_shard['shard_val'],df_shard['finddocumenttime'],xlbl,fName)

# plot the line graph for shards vs mapreduce time
fName = 'ShardsMapReduce.pdf'
plotbench(df_shard['shard_val'],df_shard['Mapreducettime'],xlbl,fName)


"""### Plots for analysing impact of replicas on bulkload, find and mapreduce"""
# selecting values from data frame where we have fixed value for shard_val == 1
df_replica = df[df.shard_val == 1]
df_replica = df_replica.sort_values(by='replica_val', ascending=1)

# plot the line graph for shards vs bulkloadtime
xlbl = 'Number of Replicas'
fName= 'ReplicasBulkLoad.pdf'
plotbench(df_replica['replica_val'],df_replica['bulkloadtime'],xlbl, fName)

# plot the line graph for shards vs find document time
fName= 'ReplicasFindDoc.pdf'
plotbench(df_replica['replica_val'],df_replica['finddocumenttime'],xlbl,fName)

# plot the line graph for shards vs mapreduce time
fName= 'ReplicasMapReduce.pdf'
plotbench(df_replica['replica_val'],df_replica['Mapreducettime'],xlbl, fName)