#! /bin/bash

arnwithqoutes=$(aws ecs describe-task-definition --task-definition test-server --region ap-south-1 | grep taskDefinitionArn | awk '{print $2}' | awk -F  "," '/1/ {print $1}')
arnwithoutqoutes=$(echo $arnwithqoutes | awk -F  '"' '/1/ {print $2}')
old_number=$(echo $arnwithoutqoutes | awk -F ":" '{print $7}')
new_number=$(( old_number+=1 ))
removerevision=$(echo $arnwithoutqoutes | cut -d ':' -f 1-6)
taskdefarn=$removerevision':'$new_number
old_taskdefarn="taskDefinitionArn"     # insert in appspec.yml file    
awk -v old="$old_taskdefarn" -v new="$taskdefarn" '{gsub(old,new); print;}' appspec.yml | tee newappspec.yml && rm -f appspec.yml && mv newappspec.yml appspec.yml
