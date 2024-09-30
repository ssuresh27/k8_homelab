#!/bin/bash
for i in $(seq 1 $2);
do
   multipass exec -n ${1}${i} -- bash /tmp/configfiles/07_initiate_master.sh
done