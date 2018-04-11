# python script that converts the csv data into proper json format that is suitable for loading data into couchDB 
# Author: Ribka Rufael
import pandas 
import urllib.request

# read wine data from UCI data repository
winedata = urllib.request.urlopen("https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv")

# load the csv file into dataframe sckipping first row
winedata_df = pandas.read_csv(winedata,skiprows=1, header=None,sep=';',names = [
        "fixed acidity",
        "volatile acidity",
        "citric acid",
        "residual sugar",
        "chlorides",
        "free sulfur dioxide",
        "total sulfur dioxide",
        "density",
        "pH",
        "sulphates",
        "alcohol",
        "quality"], dtype={
       "fixed acidity" : float,
        "volatile acidity" : float,
        "citric acid" : float,
        "residual sugar" : float,
        "chlorides" : float,
        "free sulfur dioxide" : float,
        "total sulfur dioxide" : float,
        "density" : float,
        "pH" : float,
        "sulphates" : float,
        "alcohol" : float,
        "quality" : float})
nrows,ncols = winedata_df.shape


# write the dataframe into json file
with open('winedata.json', 'w') as f:
    f.write(winedata_df.to_json(orient='records'))
    

#insert  "{ \"docs\":" text at the begning of json file because this is needed when loading json data to couchdb  
with open('winedata.json', 'r+') as f:
        content = f.read()
        f.seek(0, 0)
        f.write("{ \"docs\":" + '\n' + content)

#iappend  "}"  at the end of json file because this is needed when loading json data to couchdb
with open('winedata.json', 'a+') as f:
    f.write("}")