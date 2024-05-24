#!/bin/bash
sed -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/functions.sh

trap 'handle_error $LINENO' ERR


graph="http://temp.org/upload_${GITHUB_RUN_ID}-${GITHUB_RUN_ATTEMPT}"
echo "Graph is: ${graph}"

### delete staged graph
echo "going to delete staged graph <${config[repo_staging]}:${graph}>"
url="${config[graphdb]}/repositories/${config[repo_staging]}/rdf-graphs/service"
tmpfile=$(mktemp)
resp=$(curl -s -w "%{http_code}" -o $tmpfile -X DELETE -H 'Accept: text/plain' -G --data-urlencode "graph=${graph}"  ${url})
checkCurlCall 204 $resp $tmpfile

echo "bye!"
