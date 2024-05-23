#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/functions.sh

trap 'handle_error $LINENO' ERR


graph="http://temp.org/upload_${GITHUB_RUN_ID}-${GITHUB_RUN_ATTEMPT}"
echo "Graph is: ${graph}"

subfolder="things/persons"


keys=${!config_modelfolders[@]}
keys_sorted=$(echo $keys | tr ' ' '\n' | sort | xargs)
i=0
for key in $keys_sorted
do
  subfolder=${config_modelfolders[$key]}
  for file in $(ls ${GITHUB_WORKSPACE}/${config[modelpath]}/${subfolder}/*.ttl )
  do
    ttls[$i]=$file
    i=$(($i+1))
  done
done

echo "nr of ttl files: ${#ttls[@]} " 
for ttl in ${ttls[@]}
do
  printf "\tttl: ${ttl} \n"
done

url="${config[graphdb]}/repositories/${config[repo_staging]}/rdf-graphs/service"

for ttl in ${ttls[@]}
do
  if [ ! -f $ttl ]
  then
    echo "file not found: $ttl" >&2
    exit 1
  fi

  ### upload
  tmpfile=$(mktemp)
echo plopp
  resp=$(curl -s -w "%{http_code}" -o $tmpfile -X POST -H 'Content-Type: text/turtle' -H 'Accept: application/json' -G --data-urlencode "graph=${graph}" -T ${ttl} ${url})
  checkCurlCall 204 $resp $tmpfile

done

echo "bye!"
