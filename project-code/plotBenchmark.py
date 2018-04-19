# python script to plot benchamarking results
# Author: Ribka Rufael
import pandas 
import matplotlib.pyplot as plt

# function for plotting the graphs
def plotbench(df1,df2,xlbl):
    plt.plot(df1,df2)
    plt.ylim(ymin=0)
    plt.ylabel('Time in Seconds')
    plt.xlabel(xlbl)
    plt.legend()
    plt.show()
  
# load the couchDBfinal.csv file which contains all the bechmark results into dataframe 
df = pandas.read_csv("./CouchDBBenchmark/couchDBfinal.csv")

"""### Plots for analysing impact of Shards on bulkload, find and mapreduce"""
# selecting values from data frame where we have fixed value for replica_val == 3
df_shard = df[df.replica_val == 3]
df_shard = df_shard.sort_values(by='shard_val', ascending=1)

# plot the line graph for shards vs bulkloadtime
xlbl = 'Number of Shards'
plotbench(df_shard['shard_val'],df_shard['bulkloadtime'],xlbl)

# plot the line graph for shards vs find document time
plotbench(df_shard['shard_val'],df_shard['finddocumenttime'],xlbl)

# plot the line graph for shards vs mapreduce time
plotbench(df_shard['shard_val'],df_shard['Mapreducettime'],xlbl)


"""### Plots for analysing impact of replicas on bulkload, find and mapreduce"""
# selecting values from data frame where we have fixed value for shard_val == 1
df_shard = df[df.shard_val == 1]
df_shard = df_shard.sort_values(by='replica_val', ascending=1)

# plot the line graph for shards vs bulkloadtime
xlbl = 'Number of Replicas'
plotbench(df_shard['replica_val'],df_shard['bulkloadtime'],xlbl)

# plot the line graph for shards vs find document time
plotbench(df_shard['replica_val'],df_shard['finddocumenttime'],xlbl)

# plot the line graph for shards vs mapreduce time
plotbench(df_shard['replica_val'],df_shard['Mapreducettime'],xlbl)