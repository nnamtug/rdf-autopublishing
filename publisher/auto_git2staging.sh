#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/functions.sh

trap 'handle_error $LINENO' ERR


graph="http://temp.org/upload_${GITHUB_RUN_ID}-${GITHUB_RUN_ATTEMPT}"

ttl="${GITHUB_WORKSPACE}/model/things/some-things.ttl"
url="${config[graphdb]}/repositories/${config[repo_staging]}/rdf-graphs/service"

#echo $url
#cat $ttl

if [ ! -f $ttl ]
then
  echo "file not found: $ttl" >&2
  exit 1
fi

### curl calling template
tmpfile=$(mktemp)
resp=$(curl -v -s -w "%{http_code}" -o $tmpfile -X POST -H 'Content-Type: text/turtle' -H 'Accept: application/json' -G --data-urlencode "graph=${graph}" -T ${ttl} ${url})
checkCurlCall 204 $resp $tmpfile

echo "bye!"
