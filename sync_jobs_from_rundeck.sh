#!/bin/bash
#
# script to sync jobs from rundeck to VCS
#
set -x

if [ -z $RD_TEMP_PASSWORD ]; then
  echo "set RD_TEMP_PASSWORD env variable in user bashrc file"
fi

push_counter=0

mv -f ./genfile.txt ./genfile.txt.orig || true

for i in `find /var/rundeck/projects -type f -name project.properties -print`
do
 proj_name=$(echo $i | cut -d/ -f5)
 RD_USER="$RD_TEMP_USER" RD_PASSWORD="$RD_TEMP_PASSWORD" RD_URL=http://localhost:4440/api/19 rd projects archives export -p $proj_name -i jobs -i configs -i acls -i readmes -f ./${proj_name}.zip
 du ${proj_name}.zip >> ./genfile.txt
done

IFS=$'\n'
for x in `cat genfile.txt` 
do
echo $x
egrep -qi $x genfile.txt.orig || echo $((++push_counter))
done

if [ $push_counter -gt 0 ]; then
  git add .
  git commit -am "pushing new projects"
  git push
fi
