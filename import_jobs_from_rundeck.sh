#!/bin/bash

command -v git || exit 1
if [$? == 0]; then
 git pull
fi

for i in `ls -1 ./*.zip`;
do 
proj_name=$(echo $i|cut -d'.' -f1)
RD_USER=$RD_TEMP_USER RD_PASSWORD=$RD_TEMP_PASSWORD RD_URL=http://localhost:4440/api/19 rd proje
cts create -p $proj_name 
RD_USER=$RD_TEMP_USER RD_PASSWORD=$RD_TEMP_PASSWORD RD_URL=http://localhost:4440/api/19 rd projects import -p $proj_name -f $i
done

