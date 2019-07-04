#!/bin/bash
#
# Michael Wirz - michi.wirz@gmail.com
# Script to analyze the fio output
# Will give back the results extracted from the fio files
# per each type and blocksize
# Will transform all latency output to ms and all IOPS values from k iops to iops
#
# Script needs the output files named in special format as described in the blog post here:
#
# Supported test types:
#  Typerandread-BS8k Typerandwrite-BS8k Typeread-BS8k Typewrite-BS8k 
#  Typeread-BS1024k Typewrite-BS1024k
# 
# Script can handle the output of a single server or from multiple servers.
# If the output is from multiple server the script calculates the average value and prints this out.
# Up to 4 parallel servers are supported.


function getResults() {
file=${1}
i=0
echo "Threads" > THREADS.txt
echo "IOPS" > 0IOPS.txt
echo "IOPS" > 1IOPS.txt
echo "IOPS" > 2IOPS.txt
echo "IOPS" > 3IOPS.txt
echo "TOTAL_IOPS" > IOPS.txt
echo "Avg.Latency" > 0LAT.txt
echo "Avg.Latency" > 1LAT.txt
echo "Avg.Latency" > 2LAT.txt
echo "Avg.Latency" > 3LAT.txt
echo "SYS_CPU_Usage" > 0CPU.txt
echo "SYS_CPU_Usage" > 1CPU.txt
echo "SYS_CPU_Usage" > 2CPU.txt
echo "SYS_CPU_Usage" > 3CPU.txt
grep -iv 'All Clients' ${file} > ${file}.output
file=${file}.output

latestLat=0
while [ ${i} -ne 10 ]
do
  echo $((${i}+1)) >> THREADS.txt
  totalIOPS=0
  runCount=0
  allIOPS=$(echo $(grep groupid=${i} ${file} -a8|grep IOPS|awk -F 'IOPS=' '{print $2}'|awk -F ',' '{print $1}'))
  for IOPS in ${allIOPS}  
  do
    if [ "$(echo ${IOPS}|grep "\.")" != "" ]
    then
      if [ "$(echo ${IOPS}|grep k)" != "" ]
      then
        IOPS=${IOPS/./}
        IOPS=$((${IOPS/k/}*100))
      else
        IOPS=$(echo ${IOPS%.*})
      fi
    else 
      if [ "$(echo ${IOPS}|grep k)" != "" ]
      then
        IOPS=$(echo $((${IOPS%k}*1000)))
      fi  
    fi
     totalIOPS=$((${totalIOPS}+${IOPS}))
     echo ${IOPS} >> ${runCount}IOPS.txt
     runCount=$((${runCount}+1))
  done
  echo ${totalIOPS} >> IOPS.txt
  runCount=0
  for LAT in $(echo $(grep groupid=${i} ${file} -a8|grep -iv clat|grep -iv slat|grep lat|awk -F 'avg=' '{print $2}'|awk -F ',' '{print $1}'|awk -F '.' '{print $1}'))
  do
    if [ $((${LAT}*10)) -lt ${latestLat} ]
    then
      LAT=$((${LAT}*1000))
    fi
    echo ${LAT} >> ${runCount}LAT.txt
    latestLat=${LAT}
    runCount=$((${runCount}+1))
  done
  runCount=0
  for CPU in $(echo $(grep groupid=${i} ${file} -a18|grep cpu|awk -F 'sys=' '{print $2}'|awk -F ',' '{print $1}'))
  do
    echo ${CPU} >> ${runCount}CPU.txt
    runCount=$((${runCount}+1))
  done
  i=$((${i}+1))
done
paste -s THREADS.txt > ${file%*.txt}.result
paste -s 0IOPS.txt >> ${file%*.txt}.result
paste -s 1IOPS.txt >> ${file%*.txt}.result
paste -s 2IOPS.txt >> ${file%*.txt}.result
paste -s 3IOPS.txt >> ${file%*.txt}.result
paste -s IOPS.txt >> ${file%*.txt}.result
paste -s 0LAT.txt >> ${file%*.txt}.result
paste -s 1LAT.txt >> ${file%*.txt}.result
paste -s 2LAT.txt >> ${file%*.txt}.result
paste -s 3LAT.txt >> ${file%*.txt}.result
paste -s 0CPU.txt >> ${file%*.txt}.result
paste -s 1CPU.txt >> ${file%*.txt}.result
paste -s 2CPU.txt >> ${file%*.txt}.result
paste -s 3CPU.txt >> ${file%*.txt}.result
rm ${file}
}

function refineResults() {
type=${1}
for file in $(ls *${type}*.result)
do
  run=0
  maxRun=9
  allLat=""
  while [ ${run} -le ${maxRun} ]
  do
    count=0
    latTotal=0
    output=$((${run}+2))
    for lat in $(cat ${file}|grep Latency|awk  -v a=${output} -F ' ' '{print $a}')
    do
      latTotal=$((${lat}+${latTotal}))
      count=$((${count}+1))
    done
    avgLat=$((${latTotal}/${count}))
    avgLat=$(echo "scale=3;${avgLat}/1000"|bc|tr -d '[:space:]')
    if [ -z "${allLat}" ]
    then
      allLat=${avgLat}
     else
      allLat="${allLat} ${avgLat}"
    fi
  run=$((${run}+1))
  done
  TOTAL_IOPS=$(grep TOTAL_IOPS ${file})
  if [ ! -z "${TOTAL_IOPS}" ]
  then
    echo ${TOTAL_IOPS} >> ${type}.refined.iopt.results
  fi
  echo ${allLat}
done
}

  rm -rf *result*

for type in Typerandread-BS8k Typerandwrite-BS8k Typeread-BS8k Typewrite-BS8k Typeread-BS1024k Typewrite-BS1024k
do
  echo "###########################################"
  echo "START :${type}"
  echo "FUNCTION: getResults"
  echo "###########################################"
  for file in $(ls *${type}*.txt)
  do
    getResults ${file}
  done
  refineResults ${type} >> ${type}.refined.lat.results
  echo "${type}"
  echo "LATENCY IN MS"
  cat ${type}.refined.lat.results
  echo "IOPS"
  cat ${type}.refined.iopt.results|grep TOTAL_IOPS|awk -F "TOTAL_IOPS" '{print $2}'
done
