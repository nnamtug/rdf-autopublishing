#!/bin/bash
sed -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/functions.sh

trap 'handle_error $LINENO' ERR


graph="http://temp.org/upload_${GITHUB_RUN_ID}-${GITHUB_RUN_ATTEMPT}"
echo "Graph is: ${graph}"



### drop productive graph
url="${config[graphdb]}/repositories/${config[repo_prod]}/statements"
tmpfile=$(mktemp)
resp=$(curl -s -w "%{http_code}" -o $tmpfile -X POST -H 'Content-Type: application/rdf+xml' -H 'Accept: text/plain' -G --data-urlencode "update=DROP GRAPH <${config[graph_prod]}>" ${url})
checkCurlCall 204 $resp $tmpfile


### copy staged graph
echo "going to copy staged graph to ${config[repo_prod]}"
tmpfile=$(mktemp)
resp=$(curl -s -w "%{http_code}" -o $tmpfile -X POST -H 'Content-Type: application/rdf+xml' -H 'Accept: text/plain' -G --data-urlencode "update=INSERT { graph <${config[graph_prod]}> {?s ?p ?o} } WHERE { service <repository:${config[repo_staging]}> { values ?g { <${graph}> } graph ?g {?s ?p ?o} } }" ${url})
checkCurlCall 204 $resp $tmpfile

echo "bye!"
