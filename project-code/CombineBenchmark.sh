# bash script to combine all benchmark files
OutFName="CouchDBfinal.csv"              
i=0                                      
for FName in ./CouchDBBenchmark/benchmark_*.csv; do 
 if [ "$FName"  != "$OutFName" ] ;     
 then 
   if [[ $i -eq 0 ]] ; then 
      head -1  $FName >   ./CouchDBBenchmark/$OutFName
   fi
   tail -n +2  $FName >>  ./CouchDBBenchmark/$OutFName 
   i=$(( $i + 1 ))                        
 fi
done
