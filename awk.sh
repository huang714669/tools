#!/bin/bash
set -e

if [ $1 ];then	
  echo "decompress the gz files..."
  gzip -d -r $1
  rm -f $1/*.gz
  if [ "$?"-ne 0]; then 
	echo "decompress failed";
	exit 1;
  fi 
  for file in $1/*
  do
     #delete blank lines
     echo "wash the file data $file..."
     sed  -i '/^$/d' $file
    
     awk 'BEGIN{FS="|";OFS=","}{ \
        if($1){$1="{\"date\":\""$1"\""} \
        if($2){$2="\"field1\":\""$2"\""} \
        if($3){$3="\"field2\":\""$3"\""} \
        if($4){$4="\"field3\":\""$4"\""} \
        if($5){$5="\"JSON\":"$5"}";print} \
        }' $file > $file.tmp && mv -f $file.tmp $file 

  done
  if [ "$?"-ne 0]; then 
	echo "wash data failed";
	exit 1;
  fi
  echo "compress the gz files..."
  gzip -f -r $1
  if [ "$?"-ne 0]; then 
	echo "compress data failed";
	exit 1;
  fi
  
  echo "Success!"
else
   echo "Please provide a directory which stored the data"

fi

